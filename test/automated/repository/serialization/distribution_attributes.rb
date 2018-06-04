require_relative '../../automated_init'

context "Repository" do
  context "Serialization (JSON)" do
    context "Distribution Attributes" do
      repository = ReleaseControl::Repository.new

      repository.add_distribution('upstream') do |distribution|
        control_release = Controls::Release.example

        SetAttributes.(distribution, control_release)
      end

      json_text = Transform::Write.(repository, :json)

      test "Attributes are included in JSON document" do
        assert(JSON.parse(json_text) == JSON.parse(<<~JSON))
          {
            "distributions": [
              {
                "name": "upstream",
                "date": "2000-01-01T00:00:00.000Z",
                "description": "Some repository description",
                "origin": "some-origin",
                "label": "some-label",
                "version": "1.1",
                "validUntil": "2000-01-01T00:01:51.000Z",
                "notAutomatic": true,
                "butAutomaticUpgrades": true,
                "acquireByHash": false,
                "signedBy": "AAAA BBBB CCCC DDDD, 0000 1111 2222 3333"
              }
            ],

            "packages": []
          }
        JSON
      end
    end
  end
end
