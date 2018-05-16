require_relative '../../automated_init'

context "Repository" do
  context "Add Package" do
    context "Distribution Already Added" do
      repository = Repository.new

      name = Controls::Package.package
      version = Controls::Package.version
      distribution = Controls::Distribution.example

      repository.add_distribution(distribution) do |distribution|
        distribution.description = 'Some description'
      end

      repository.add_package(name, version, distribution)

      test "Existing distribution data is preserved" do
        distribution = repository.get_distribution(distribution)

        assert(distribution.description == 'Some description')
      end
    end
  end
end
