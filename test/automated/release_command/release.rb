require_relative '../automated_init'

context "Release Command" do
  context "Release" do
    source_archive = Controls::SourceArchive.example

    distribution = Controls::Distribution.example
    component = Controls::Component.example

    release = Commands::Release.new
    release.component = component

    release.package_definition_root = Controls::PackageDefinition::Root.example

    deb_file = release.(source_archive, distribution)

    refute(deb_file.nil?)

    test "Debian file is generated and published" do
      published = release.publish.published?(deb_file) do |_, dist, comp|
        dist == distribution && comp == component
      end

      assert(published)
    end
  end
end
