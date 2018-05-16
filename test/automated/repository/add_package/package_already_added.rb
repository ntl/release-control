require_relative '../../automated_init'

context "Repository" do
  context "Add Package" do
    context "Package Already Added" do
      repository = Repository.new

      name = Controls::Package.package
      version = Controls::Package.version
      distribution = Controls::Distribution.example

      repository.add_package(name, version, distribution) do |package|
        package.description = 'Some package description'
      end

      repository.add_package(name, version, distribution)

      test "Existing package data is preserved" do
        package = repository.get_package(name)

        assert(package.get_version(version).description == 'Some package description')
      end
    end
  end
end
