require_relative '../../automated_init'

context "Repository" do
  context "Serialization (JSON)" do
    context "Control" do
      repository = Controls::Repository.example

      json_text = Transform::Write.(repository, :json)

      test do
        assert(JSON.parse(json_text) == Controls::Repository::JSON.data)
      end
    end
  end
end
