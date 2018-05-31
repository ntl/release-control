require_relative '../automated_init'

context "Copy Package" do
  context "Copied" do
    source_index_entry = Controls::PackageIndex::Entry.example
    source_package_index = Controls::PackageIndex.example(entries: [source_index_entry])

    component = Controls::Component.example
    architecture = Controls::Architecture.example

    package = source_index_entry.package
    version = source_index_entry.version

    source_distribution = Controls::Distribution.example
    target_distribution = Controls::Distribution::Alternate.example

    copy_package = Commands::CopyPackage.new

    copy_package.component = component
    copy_package.architecture = architecture

    package_index_store = copy_package.package_index_store

    package_index_store.add(
      source_package_index,
      distribution: source_distribution,
      component: component,
      architecture: architecture
    )

    copy_package.(package, version, source_distribution, target_distribution)

    test "Package index entry from existing distribution is added to new distribution" do
      control_object_key = "dists/#{target_distribution}/#{component}/binary-#{architecture}/Packages.gz"

      added = package_index_store.put? do |package_index, object_key|
        package_index.entries.include?(source_index_entry) && object_key == control_object_key
      end

      assert(added)
    end
  end
end
