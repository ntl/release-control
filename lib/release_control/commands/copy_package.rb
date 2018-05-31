module ReleaseControl
  module Commands
    class CopyPackage
      include Log::Dependency

      configure :copy_package

      dependency :package_index_store, Packaging::Debian::Repository::S3::PackageIndex::Store

      setting :component
      setting :architecture

      def configure
        Packaging::Debian::Repository::S3::PackageIndex::Store.configure(self, attr_name: :package_index_store)

        Settings.set(self)
      end

      def self.build
        instance = new
        instance.configure
        instance
      end

      def self.call(*arguments)
        instance = build
        instance.(*arguments)
      end

      def call(package, version, source_distribution, target_distribution)
        log_attributes = "Package: #{package.inspect}, Version: #{version.inspect}, Source Distribution: #{source_distribution.inspect}, Target Distribution: #{target_distribution.inspect}"

        logger.trace { "Copying package (#{log_attributes})" }

        source_package_index = package_index_store.fetch(distribution: source_distribution, component: component, architecture: architecture)

        target_package_index = package_index_store.fetch(distribution: target_distribution, component: component, architecture: architecture)

        entry = source_package_index.entries.find do |entry|
          entry.package == package && entry.version == version
        end

        if entry.nil?
          error_message = "Source package not found (#{log_attributes})"
          logger.error { error_message }
          raise SourcePackageNotFound, error_message
        end

        target_package_index.add_entry(entry)

        package_index_store.put(target_package_index, distribution: target_distribution, component: component, architecture: architecture)

        logger.info { "Copied package (#{log_attributes})" }

        entry
      end

      SourcePackageNotFound = Class.new(StandardError)
    end
  end
end
