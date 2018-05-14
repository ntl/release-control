module ReleaseControl
  module Queries
    module Distribution
      class List
        include Log::Dependency

        configure :get_distributions

        dependency :get_object, AWS::S3::Client::Object::Get
        dependency :package_index_store, Packaging::Debian::Repository::S3::PackageIndex::Store

        setting :distributions
        setting :component
        setting :architecture

        def configure
          Settings.set(self)
          AWS::S3::Client::Object::Get.configure(self)
          Packaging::Debian::Repository::S3::PackageIndex::Store.configure(self)
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
          logger.trace { "Getting list of distributions (Distributions: #{distributions * ', '})" }

          result = Result.new

          distributions.each do |distribution_name|
            object_key = in_release_path(distribution_name)

            release_text = get_object.(object_key)

            unless release_text.nil?
              release = Transform::Read.(release_text, :rfc822_signed, Packaging::Debian::Repository::S3::Release)
            else
              release = new_release(distribution_name)
            end

            distribution = ReleaseControl::Distribution.new
            distribution.name = distribution_name
            distribution.component = component
            distribution.architecture = architecture

            SetAttributes.(distribution, release)

            package_index = package_index_store.get(
              distribution: distribution_name,
              component: component,
              architecture: architecture
            )

            distribution.package_index = package_index unless package_index.nil?

            result.add(distribution)
          end

          logger.debug { "Get list of distributions done (Distributions: #{distributions * ', '})" }

          result
        end

        def new_release(distribution)
          release = Packaging::Debian::Schemas::Release.new
          release.suite = distribution
          release.components = Set.new([component])
          release.architectures = Set.new([architecture])
          release
        end

        def in_release_path(distribution)
          File.join('dists', distribution, 'InRelease')
        end
      end
    end
  end
end
