require_relative '../../automated_init'

context "Repository" do
  context "Serialization (JSON)" do
    context "No Distribution" do
      repository = ReleaseControl::Repository.new

      repository.add_package('some-package', '1.1.1', 'some-distribution')

      json_text = Transform::Write.(repository, :json)

      test "Distribution entry is added" do
        assert(JSON.parse(json_text) == JSON.parse(<<~JSON))
          {
            "distributions": [
              {
                "name": "some-distribution",
                "packages": [
                  {
                    "name": "some-package",
                    "versions": ["1.1.1"]
                  }
                ]
              }
            ],

            "packages": [
              {
                "name": "some-package",
                "versions": [
                  {
                    "value": "1.1.1",
                    "distributions": ["some-distribution"]
                  }
                ]
              }
            ]
          }
        JSON
      end
    end
  end
end

