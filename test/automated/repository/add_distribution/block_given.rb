require_relative '../../automated_init'

context "Repository" do
  context "Add Distribution" do
    context "Block Given" do
      repository = Repository.new

      name = Controls::Distribution.example

      distribution = repository.add_distribution(name) do |dist|
        dist.description = 'Some description'
      end

      test "Block is executed and given the distribution" do
        assert(distribution.description == 'Some description')
      end
    end
  end
end
