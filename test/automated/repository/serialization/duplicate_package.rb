require_relative '../../automated_init'

context "Repository" do
  context "Serialization (JSON)" do
    context "Duplicate Package" do
      repository = ReleaseControl::Repository.new

      repository.add_package('some-package', '1.1.1', 'upstream') do |package|
        package.description = 'Some description'
      end

      repository.add_package('some-package', '1.1.1', 'downstream') do |package|
        package.depends = 'some-dependency'
      end

      json_text = Transform::Write.(repository, :json)

      test "Properties of each package addition are merged" do
        assert(JSON.parse(json_text) == JSON.parse(<<~JSON))
          {
            "distributions": [
              {
                "name": "downstream",
                "packages": [
                  {
                    "name": "some-package",
                    "versions": ["1.1.1"]
                  }
                ]
              },{
                "name": "upstream",
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
                    "description": "Some description",
                    "depends": "some-dependency",
                    "distributions": ["downstream", "upstream"]
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
