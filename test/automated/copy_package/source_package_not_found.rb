require_relative '../automated_init'

context "Copy Package" do
  context "Source Package Not Found" do
    package = Controls::Package.package
    version = Controls::Package.version

    source_distribution = Controls::Distribution.example
    target_distribution = Controls::Distribution::Alternate.example

    copy_package = Commands::CopyPackage.new

    copy_package.component = Controls::Component.example
    copy_package.architecture = Controls::Architecture.example

    package_index_store = copy_package.package_index_store

    test "Raises error" do
      assert proc { copy_package.(package, version, source_distribution, target_distribution) } do
        raises_error?(Commands::CopyPackage::SourcePackageNotFound)
      end
    end
  end
end
