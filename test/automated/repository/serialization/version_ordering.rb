require_relative '../../automated_init'

context "Repository" do
  context "Serialization (JSON)" do
    context "Version Ordering" do
      repository = ReleaseControl::Repository.new

      repository.add_package('some-package', '1.1.1', 'upstream')
      repository.add_package('some-package', '1.1.0', 'upstream')
      repository.add_package('some-package', '1.1.2', 'upstream')
      repository.add_package('some-package', '1.1.11', 'upstream')

      json_text = Transform::Write.(repository, :json)

      test "Versions are sorted from highest to lowest" do
        assert(JSON.parse(json_text) == JSON.parse(<<~JSON))
        {
          "distributions": [
            {
              "name": "upstream",
              "packages": [
                {
                  "name": "some-package",
                  "versions": ["1.1.11", "1.1.2", "1.1.1", "1.1.0"]
                }
              ]
            }
          ],

          "packages": [
            {
              "name": "some-package",
              "versions": [
                {
                  "value": "1.1.11",
                  "distributions": ["upstream"]
                },{
                  "value": "1.1.2",
                  "distributions": ["upstream"]
                },{
                  "value": "1.1.1",
                  "distributions": ["upstream"]
                },{
                  "value": "1.1.0",
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
