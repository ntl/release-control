require_relative '../../automated_init'

context "Repository" do
  context "Serialization (JSON)" do
    context "Multiple Distributions" do
      repository = ReleaseControl::Repository.new

      repository.add_package('some-package', '2.2.2', ['a-distribution'])
      repository.add_package('some-package', '1.1.1', ['b-distribution', 'a-distribution'])
      repository.add_package('other-package', '1.1.1', ['b-distribution'])

      json_text = Transform::Write.(repository, :json)

      test "Each distribution entry includes constituent packages" do
        assert(JSON.parse(json_text) == JSON.parse(<<~JSON))
          {
            "distributions": [
              {
                "name": "a-distribution",
                "packages": [
                  {
                    "name": "some-package",
                    "versions": ["2.2.2", "1.1.1"]
                  }
                ]
              },{
                "name": "b-distribution",
                "packages": [
                  {
                    "name": "other-package",
                    "versions": ["1.1.1"]
                  },{
                    "name": "some-package",
                    "versions": ["1.1.1"]
                  }
                ]
              }
            ],

            "packages": [
              {
                "name": "other-package",
                "versions": [
                  {
                    "value": "1.1.1",
                    "distributions": ["b-distribution"]
                  }
                ]
              },{
                "name": "some-package",
                "versions": [
                  {
                    "value": "2.2.2",
                    "distributions": ["a-distribution"]
                  },{
                    "value": "1.1.1",
                    "distributions": ["a-distribution", "b-distribution"]
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
