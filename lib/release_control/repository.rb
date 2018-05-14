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

    def add_distribution(name, &block)
      distribution = Distribution.new

      distribution.name = name

      block.(distribution) unless block.nil?

      distributions[name] = distribution

      distribution
    end

    def get_package(name)
      packages[name] ||= Package.new(name)
    end

    def get_distribution(name)
      distributions[name] ||= add_distribution(name)
    end
  end
end
