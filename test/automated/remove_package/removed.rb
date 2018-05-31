require_relative '../automated_init'

context "Remove Package" do
  context "Removed" do
    index_entry = Controls::PackageIndex::Entry.example
    other_index_entry = Controls::PackageIndex::Entry::Alternate.example

    package_index = Controls::PackageIndex.example(entries: [index_entry, other_index_entry])

    package = index_entry.package
    version = index_entry.version

    distribution = Controls::Distribution.example
    component = Controls::Component.example
    architecture = Controls::Architecture.example

    remove_package = Commands::RemovePackage.new

    remove_package.component = component
    remove_package.architecture = architecture

    package_index_store = remove_package.package_index_store

    package_index_store.add(
      package_index,
      distribution: distribution,
      component: component,
      architecture: architecture
    )

    remove_package.(package, version, distribution)

    test "Package index for distribution is uploaded with corresponding entry removed" do
      control_object_key = "dists/#{distribution}/#{component}/binary-#{architecture}/Packages.gz"

      removed = package_index_store.put? do |package_index, object_key|
        package_index.entries == [other_index_entry] && object_key == control_object_key
      end

      assert(removed)
    end
  end
end
