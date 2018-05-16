require_relative '../../automated_init'

context "Repository" do
  context "Add Distribution" do
    repository = Repository.new

    name = Controls::Distribution.example

    distribution = repository.add_distribution(name)

    test "Distribution is returned" do
      assert(distribution.instance_of?(Repository::Distribution))
    end

    test "Distribution is added" do
      assert(repository.distributions[name] == distribution)
    end

    test "Name" do
      assert(distribution.name == name)
    end
  end
end
