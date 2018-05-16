require_relative '../../automated_init'

context "Repository" do
  context "Add Distribution" do
    context "Already Added" do
      repository = Repository.new

      name = Controls::Distribution.example

      repository.add_distribution(name) do |dist|
        dist.description = 'Some description'
      end

      repository.add_distribution(name)

      test "Previously added distribution is unchanged" do
        dist = repository.get_distribution(name)

        assert(dist.description == 'Some description')
      end
    end
  end
end
