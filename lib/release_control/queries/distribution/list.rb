module ReleaseControl
  module Queries
    module Distribution
      class List
        include Log::Dependency

        configure :get_distributions

        dependency :get_object, AWS::S3::Client::Object::Get

        setting :distributions
        setting :components
        setting :architectures

        def configure
          Settings.set(self)
          AWS::S3::Client::Object::Get.configure(self)
        end

        def self.build
          instance = new
          instance.configure
          instance
        end

        def self.call
          instance = build
          instance.()
        end

        def call
          logger.trace { "Getting list of distributions (Distributions Setting: #{distributions * ', '})" }

          result = Result.new

          distributions.each do |distribution|
            object_key = in_release_path(distribution)

            release_text = get_object.(object_key)

            unless release_text.nil?
              release = Transform::Read.(release_text, :rfc822_signed, Packaging::Debian::Repository::S3::Release)
            else
              release = new_release(distribution)
            end

            result[distribution] = release
          end

          logger.debug { "Get list of distributions done (Distributions: #{distributions * ', '})" }

          result
        end

        def new_release(distribution)
          release = Packaging::Debian::Schemas::Release.new
          release.components = self.components
          release.architectures = self.architectures
          release
        end

        def in_release_path(distribution)
          File.join('dists', distribution, 'InRelease')
        end
      end
    end
  end
end
