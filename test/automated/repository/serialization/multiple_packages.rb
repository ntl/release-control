require_relative '../../automated_init'

context "Repository" do
  context "Serialization (JSON)" do
    context "Multiple Packages" do
      repository = ReleaseControl::Repository.new

      repository.add_package('b-some-package', '1.1.1', 'upstream')
      repository.add_package('a-other-package', '1.1.1', 'upstream')

      json_text = Transform::Write.(repository, :json)

      test "Packages are organized in alphabetical order" do
        assert(JSON.parse(json_text) == JSON.parse(<<~JSON))
          {
            "distributions": [
              {
                "name": "upstream",
                "packages": [
                  {
                    "name": "a-other-package",
                    "versions": ["1.1.1"]
                  },{
                    "name": "b-some-package",
                    "versions": ["1.1.1"]
                  }
                ]
              }
            ],

            "packages": [
              {
                "name": "a-other-package",
                "versions": [
                  {
                    "value": "1.1.1",
                    "distributions": ["upstream"]
                  }
                ]
              },{
                "name": "b-some-package",
                "versions": [
                  {
                    "value": "1.1.1",
                    "distributions": ["upstream"]
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
