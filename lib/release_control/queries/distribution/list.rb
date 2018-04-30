module ReleaseControl
  module Queries
    module Distribution
      class List
        include Log::Dependency

        configure :get_distributions

        dependency :get_object, AWS::S3::Client::Object::Get

        setting :distributions

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

          get_distributions = {}

          distributions.each do |distribution|
            object_key = in_release_path(distribution)

            release_text = get_object.(object_key)

            next if release_text.nil?

            release = Transform::Read.(release_text, :rfc822_signed, Packaging::Debian::Repository::S3::Release)

            get_distributions[distribution] = release
          end

          logger.debug { "Get list of distributions done (Distributions Setting: #{distributions * ', '}, Distributions: #{get_distributions.keys * ', '})" }

          get_distributions
        end

        def in_release_path(distribution)
          File.join('dists', distribution, 'InRelease')
        end
      end
    end
  end
end
