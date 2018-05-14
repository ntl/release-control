module ReleaseControl
  class Repository
    include Schema::DataStructure

    attribute :distributions, Hash, default: proc { Hash.new }
    attribute :packages, Hash, default: proc { Hash.new }

    def add_package(name, version, distributions, &block)
      distributions = Array(distributions)

      package = packages[name] ||= Package.build(name)

      package.name = name

      package.add_version(version, distributions, &block)

      distributions.each do |distribution_name|
        distribution = get_distribution(distribution_name)

        distribution.add_package(name, version)
      end

      package
    end

    def add_distribution(name, &block)
      distribution = Distribution.new

      distribution.name = name

      block.(distribution) unless block.nil?

      distributions[name] = distribution

      distribution
    end

    def get_distribution(name)
      distributions[name] || add_distribution(name)
    end

    class Distribution
      include Schema::DataStructure

      attribute :name, String
      attribute :date, Time

      attribute :description, String
      attribute :origin, String
      attribute :label, String
      attribute :version, String

      attribute :valid_until, Time

      attribute :not_automatic
      attribute :but_automatic_upgrades
      attribute :acquire_by_hash

      attribute :signed_by, String

      attribute :packages, Hash, default: proc { Hash.new }

      def add_package(package_name, version)
        package = packages[package_name] ||= Package.build(package_name)

        package.add_version(version)

        package
      end

      Package = Struct.new(:name, :versions) do
        def self.build(name, versions=nil)
          versions = Array(versions)

          versions = Set.new(versions)

          new(name, versions)
        end

        def add_version(version)
          self.versions << version
        end
      end
    end

    Package = Struct.new(:name, :versions) do
      def self.build(name)
        versions = {}

        new(name, versions)
      end

      def add_version(value, distributions, &block)
        version = get_version(value)

        version.distributions += Set.new(distributions)

        block.(version) unless block.nil?

        version
      end

      def get_version(value)
        versions[value] ||= Version.build(value: value)
      end

      class Version
        include Schema::DataStructure

        include Packaging::Debian::Schemas::Package::Attributes

        attribute :distributions, Set, default: proc { Set.new }

        alias_method :value, :version
        alias_method :value=, :version=
      end
    end

    module Transform
      def self.json
        JSON
      end

      def self.raw_data(instance)
        data = {}

        distributions = instance.distributions.each_value.sort do |a, b|
          a.name <=> b.name
        end

        distributions = distributions.map do |distribution|
          distribution_data = distribution.to_h

          packages = distribution_data.delete(:packages)

          packages = packages.each_value.sort do |a, b|
            a.name <=> b.name
          end

          packages = packages.map do |package|
            versions = package.versions.to_a.sort do |a, b|
              compare_versions(b, a)
            end

            { :name => package.name, :versions => versions }
          end

          distribution_data.delete_if { |k, v| v.nil? }

          distribution_data[:packages] = packages unless packages.empty?

          date = distribution_data.delete(:date)
          distribution_data[:date] = Clock.iso8601(date) unless date.nil?

          valid_until = distribution_data.delete(:valid_until)
          distribution_data[:valid_until] = Clock.iso8601(valid_until) unless valid_until.nil?

          distribution_data
        end

        data[:distributions] = distributions unless distributions.empty?

        packages = instance.packages.each_value.sort do |a, b|
          a.name <=> b.name
        end

        packages = packages.map do |package|
          versions = package.versions.each_value.sort do |a, b|
            compare_versions(b.value, a.value)
          end

          versions = versions.map do |version|
            distributions = version.distributions.sort

            version_data = version.to_h

            version_data.delete_if { |k, v| v.nil? }

            value = version_data.delete(:version)

            version_data.delete(:package)

            version_data.update({
              :value => value,
              :distributions => distributions
            })

            version_data
          end

          { :name => package.name, :versions => versions }
        end

        data[:packages] = packages unless packages.empty?

        data
      end

      def self.compare_versions(v1, v2)
        Gem::Version.new(v1) <=> Gem::Version.new(v2)
      end

      module JSON
        def self.write(raw_data)
          formatted_data = Casing::Camel.(raw_data)

          ::JSON.pretty_generate(formatted_data)
        end
      end
    end
  end
end
