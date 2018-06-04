require_relative '../../automated_init'

context "Repository" do
  context "Serialization (JSON)" do
    context "No Packages" do
      repository = ReleaseControl::Repository.new

      repository.add_distribution('some-distribution')

      json_text = Transform::Write.(repository, :json)

      test "Packages entry is an empty array" do
        assert(JSON.parse(json_text) == JSON.parse(<<~JSON))
          {
            "distributions": [
              {
                "name": "some-distribution"
              }
            ],

            "packages": []
          }
        JSON
      end
    end
  end
end
