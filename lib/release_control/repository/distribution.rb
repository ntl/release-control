module ReleaseControl
  class Repository
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

      def add_package(name, version)
        package = get_package(name)
        package.add_version(version)
        package
      end

      def get_package(name)
        packages[name] ||= Package.new(name)
      end

      def package?(name)
        packages.key?(name)
      end

      class Package
        initializer :name

        def versions
          @versions ||= Set.new
        end

        def add_version(version)
          self.versions << version
        end
      end
    end
  end
end
