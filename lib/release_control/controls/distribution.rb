module ReleaseControl
  module Controls
    module Distribution
      def self.example(name: nil, release_data: nil)
        name ||= self.name
        release_data ||= self.release_data

        distribution = ReleaseControl::Distribution.new
        distribution.name = name

        SetAttributes.(distribution, release_data)

        package_index = PackageIndex.example
        distribution.package_index = package_index

        distribution.architecture = Architecture.example
        distribution.component = Component.example

        distribution
      end

      def self.name
        Packaging::Debian::Repository::S3::Controls::Distribution.example
      end

      def self.release_data
        Packaging::Debian::Schemas::Controls::Release::Data.example
      end

      module Alternate
        def self.example
          Distribution.example(
            name: name,
            release_data: release_data
          )
        end

        def self.name
          Packaging::Debian::Repository::S3::Controls::Distribution::Alternate.example
        end

        def self.release_data
          Packaging::Debian::Schemas::Controls::Release::Alternate::Data.example
        end
      end
    end

    module Distribution
      module List
        def self.example
          [Distribution.example, Alternate.example]
        end
      end
    end
  end
end
