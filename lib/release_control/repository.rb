module ReleaseControl
  class Repository
    include Schema::DataStructure

    attribute :distributions, Hash, default: proc { Hash.new }
    attribute :packages, Hash, default: proc { Hash.new }

    def add_package(name, version, distributions, &block)
      distributions = Array(distributions)

      package = get_package(name)

      package.add_version(version, distributions, &block)

      distributions.each do |distribution_name|
        distribution = get_distribution(distribution_name)

        distribution.add_package(name, version)
      end

      package
    end

    def package?(name, version: nil)
      package = packages[name]

      return false if package.nil?

      if version.nil?
        true
      else
        package.version?(version)
      end
    end

    def get_package(name, version: nil)
      packages[name] ||= Package.new(name)

      if version.nil?
        packages[name]
      else
        packages[name].get_version(version)
      end
    end

    def add_distribution(name, &block)
      distribution = get_distribution(name)

      block.(distribution) unless block.nil?

      distribution
    end

    def distribution?(name)
      distributions.key?(name)
    end

    def get_distribution(name)
      distributions[name] ||= Distribution.build(name: name)
    end
  end
end
