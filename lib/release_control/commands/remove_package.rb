module ReleaseControl
  module Commands
    class RemovePackage
      include Log::Dependency

      configure :remove_package

      dependency :package_index_store, Packaging::Debian::Repository::S3::PackageIndex::Store

      setting :component
      setting :architecture

      def configure
        Packaging::Debian::Repository::S3::PackageIndex::Store.configure(self)

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

      def call(package, version, distribution)
        log_attributes = "Package: #{package.inspect}, Version: #{version.inspect}, Distribution: #{distribution.inspect}"

        logger.trace { "Removing package (#{log_attributes})" }

        package_index = package_index_store.fetch(distribution: distribution, component: component, architecture: architecture)

        entry = package_index.entries.find do |entry|
          entry.package == package && entry.version == version
        end

        if entry.nil?
          error_message = "Package not found (#{log_attributes})"
          logger.error { error_message }
          raise SourcePackageNotFound, error_message
        end

        removed = package_index.remove_entry(entry)

        package_index_store.put(package_index, distribution: distribution, component: component, architecture: architecture)

        logger.info { "Removed package (#{log_attributes})" }

        removed
      end

      SourcePackageNotFound = Class.new(StandardError)
    end
  end
end
