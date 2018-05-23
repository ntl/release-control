module ReleaseControl
  module Controls
    module Repository
      module JSON
        def self.text
          <<~JSON
            {
              "distributions": [
                {
                  "name": "other-distribution",
                  "description": "Example distribution (other)",
                  "date": "2000-01-01T00:00:00.000Z",
                  "packages": [
                    {
                      "name": "current-package",
                      "versions": ["2.2.2", "1.1.1"]
                    },{
                      "name": "other-package",
                      "versions": ["1.1.1"]
                    },{
                      "name": "some-package",
                      "versions": ["1.1.1"]
                    }
                  ]
                },{
                  "name": "some-distribution",
                  "description": "Example distribution",
                  "date": "2000-01-01T00:00:00.000Z",
                  "packages": [
                    {
                      "name": "current-package",
                      "versions": ["2.2.2", "1.1.1"]
                    },{
                      "name": "some-package",
                      "versions": ["2.2.2", "1.1.1"]
                    }
                  ]
                }
              ],

              "packages": [
                {
                  "name": "current-package",
                  "versions": [
                    {
                      "value": "2.2.2",
                      "section": "current-package-section",
                      "description": "Example package (current)",
                      "depends": "current-package-dependency",
                      "distributions": ["other-distribution", "some-distribution"]
                    },{
                      "value": "1.1.1",
                      "section": "current-package-section",
                      "description": "Example package (current)",
                      "depends": "current-package-dependency",
                      "distributions": ["other-distribution", "some-distribution"]
                    }
                  ]
                },
                {
                  "name": "other-package",
                  "versions": [
                    {
                      "value": "1.1.1",
                      "section": "other-section",
                      "description": "Example package (other)",
                      "depends": "other-dependency",
                      "distributions": ["other-distribution"]
                    }
                  ]
                },{
                  "name": "some-package",
                  "versions": [
                    {
                      "value": "2.2.2",
                      "section": "some-section",
                      "description": "Example package (current version)",
                      "depends": "some-dependency",
                      "distributions": ["some-distribution"]
                    },{
                      "value": "1.1.1",
                      "section": "some-section",
                      "description": "Example package (older version)",
                      "depends": "some-older-dependency",
                      "distributions": ["other-distribution", "some-distribution"]
                    }
                  ]
                }
              ]
            }
          JSON
        end

        def self.data
          text = self.text

          ::JSON.parse(text)
        end
      end
    end
  end
end
