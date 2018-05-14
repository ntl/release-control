require_relative '../../automated_init'

context "Repository" do
  context "Serialization (JSON)" do
    context "Package Attributes" do
      repository = ReleaseControl::Repository.new

      control_package = Controls::Package.example

      repository.add_package('some-package', '1.1.1', 'upstream') do |package|
        SetAttributes.(package, control_package, exclude: [:version, :package])
      end

      json_text = Transform::Write.(repository, :json)

      test "Attributes are included in JSON document" do
        assert(JSON.parse(json_text) == JSON.parse(<<~JSON))
          {
            "distributions": [
              {
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
                    "source": "some-source-package (1.1.1-11)",
                    "section": "some-section",
                    "priority": "optional",
                    "architecture": "i386",
                    "essential": true,
                    "depends": "some-dependency",
                    "preDepends": "some-pre-dependency",
                    "recommends": "some-recommended-dependency",
                    "suggests": "some-suggested-dependency",
                    "enhances": "some-enhanced-dependency",
                    "breaks": "some-broken-dependency",
                    "conflicts": "some-conflicted-dependency",
                    "installedSize": 1111,
                    "maintainer": "Some Maintainer <some.maintainer@example.com>",
                    "description": "Some package",
                    "homepage": "http://example.com",
                    "builtUsing": "gcc-1.11",
                    "distributions": ["upstream"],
                    "value": "1.1.1"
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
