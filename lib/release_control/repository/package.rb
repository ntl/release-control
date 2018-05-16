module ReleaseControl
  class Repository
    class Package
      initializer :name

      def add_version(value, distributions, &block)
        distributions = Set.new(distributions) unless distributions.is_a?(Set)

        version = get_version(value)

        version.distributions.merge(distributions)

        block.(version) unless block.nil?

        version
      end

      def get_version(value)
        versions[value] ||= Version.build(value: value)
      end

      def version?(value)
        versions.key?(value)
      end

      def versions
        @versions ||= {}
      end

      class Version
        include Schema::DataStructure

        include Packaging::Debian::Schemas::Package::Attributes

        attribute :distributions, Set, default: proc { Set.new }

        alias_method :value, :version
        alias_method :value=, :version=
      end
    end
  end
end
