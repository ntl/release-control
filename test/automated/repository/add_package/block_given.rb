require_relative '../../automated_init'

context "Repository" do
  context "Add Package" do
    context "Block Given" do
      repository = Repository.new

      name = Controls::Package.package
      version = Controls::Package.version
      distributions = Controls::Distribution::List.example

      package = repository.add_package(name, version, distributions) do |package_version|
        package_version.description = 'Some description'
      end

      test "Block is executed and given the package version" do
        package_version = package.get_version(version) or fail

        assert(package_version.description == 'Some description')
      end
    end
  end
end
