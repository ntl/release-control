module ReleaseControl
  module Commands
    class Release
      include Log::Dependency

      configure :release

      setting :component

      attr_writer :package_definition_root
      def package_definition_root
        @package_definition_root ||= Defaults.package_definition_root
      end

      dependency :publish, Packaging::Debian::Repository::S3::Commands::Package::Publish

      def configure
        Settings.set(self)

        Packaging::Debian::Repository::S3::Commands::Package::Publish.configure(self, component: component)
      end

      def self.build
        instance = new
        instance.configure
        instance
      end

      def call(source_archive, distribution, logger: nil)
        logger ||= self.logger

        logger.trace { "Releasing package (File: #{source_archive.inspect}, Distribution: #{distribution})" }

        package = Packaging::Debian::Package.build(source_archive)
        package.package_definition_root = package_definition_root unless package_definition_root.nil?
        package.logger = logger

        deb_file = package.()

        publish.(deb_file, distribution: distribution, component: component)

        logger.info { "Package released (File: #{source_archive.inspect}, Distribution: #{distribution})" }

        deb_file
      end

      module Defaults
        def self.package_definition_root
          File.join(Dir.cwd, 'packages')
        end
      end
    end
  end
end
