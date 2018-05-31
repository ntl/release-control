require_relative '../automated_init'

context "Remove Package" do
  context "Package Not Found" do
    package = Controls::Package.package
    version = Controls::Package.version

    distribution = Controls::Distribution.example
    component = Controls::Component.example
    architecture = Controls::Architecture.example

    remove_package = Commands::RemovePackage.new

    remove_package.component = component
    remove_package.architecture = architecture

    test "Raises error" do
      assert proc { remove_package.(package, version, distribution) } do
        raises_error?(Commands::RemovePackage::SourcePackageNotFound)
      end
    end
  end
end
