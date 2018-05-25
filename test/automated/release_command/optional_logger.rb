require_relative '../automated_init'

context "Release Command" do
  context "Release" do
    context "Optional Logger" do
      source_archive = Controls::SourceArchive.example

      distribution = Controls::Distribution.example
      component = Controls::Component.example

      release = Commands::Release.new
      release.component = component

      release.package_definition_root = Controls::PackageDefinition::Root.example

      logger = Log.build('test')
      logger.device = log_device = StringIO.new

      deb_file = release.(source_archive, distribution, logger: logger)

      refute(deb_file.nil?)

      test "Output of packaging is logged" do
        refute(log_device.string.empty?)
      end
    end
  end
end
