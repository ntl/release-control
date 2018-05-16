require_relative '../../automated_init'

context "Repository" do
  context "Add Package" do
    context "New Version Added" do
      repository = Repository.new

      name = Controls::Package.package

      previous_version = '1.1.1'
      version = '2.0.0'

      distribution = Controls::Distribution.example

      repository.add_package(name, previous_version, distribution) do |package|
        package.description = 'Older package description'
      end

      repository.add_package(name, version, distribution) do |package|
        package.description = 'Newer package description'
      end

      package = repository.get_package(name)

      test "Old version is preserved" do
        assert(package.get_version(previous_version).description == 'Older package description')
      end

      test "New Version is added" do
        assert(package.get_version(version).description == 'Newer package description')
      end
    end
  end
end
