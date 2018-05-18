module ReleaseControl
  class Repository
    class Get
      include Log::Dependency

      configure :get_repository

      dependency :release_store, Packaging::Debian::Repository::S3::Release::Store
      dependency :package_index_store, Packaging::Debian::Repository::S3::PackageIndex::Store

      setting :distributions
      setting :component
      setting :architecture

      def configure
        distribution = nil

        Packaging::Debian::Repository::S3::Release::Store.configure(self, distribution, attr_name: :release_store)
        Packaging::Debian::Repository::S3::PackageIndex::Store.configure(self, distribution, attr_name: :package_index_store)

        Settings.set(self)
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
        logger.trace { "Getting repository (Distributions: #{distributions.inspect}, Component: #{component || '(none)'}, Architecture: #{architecture || '(none)'})" }

        repository = Repository.new

        distributions.each do |distribution|
          package_index = package_index_store.fetch(
            distribution: distribution,
            component: component,
            architecture: architecture
          )

          package_index.each do |package|
            repository.add_package(package.name, package.version, distribution) do |version|
              SetAttributes.(version, package)
            end
          end

          repository.add_distribution(distribution) do |dist|
            release = release_store.get(distribution: distribution)

            SetAttributes.(dist, release, copy: [
              { :suite => :name },
              :date,
              :description,
              :origin,
              :label,
              :version,
              :valid_until,
              :not_automatic,
              :but_automatic_upgrades,
              :acquire_by_hash,
              :signed_by
            ])
          end
        end

        logger.info { "Get repository done (Distributions: #{distributions.inspect}, Component: #{component || '(none)'}, Architecture: #{architecture || '(none)'})" }

        repository
      end
    end
  end
end
