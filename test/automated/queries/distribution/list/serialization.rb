require_relative '../../../automated_init'

context "Queries" do
  context "Distribution" do
    context "List" do
      context "Serialization" do
        get_distributions = Queries::Distribution::List.new

        distributions = Controls::Distribution::List.example
        components = Controls::Release.components
        architectures = Controls::Release.architectures

        get_distributions.distributions = distributions
        get_distributions.components = components
        get_distributions.architectures = architectures

        get_object = get_distributions.get_object

        configured_release_text = Controls::Release::Text::Signed.example
        get_object.add("dists/#{distributions[0]}/InRelease", configured_release_text)

        result = get_distributions.()

        context "JSON Text" do
          text = Transform::Write.(result, :json)

          test "Valid JSON" do
            refute proc { JSON.parse(text) } do
              raises_error?
            end
          end

          test "Can be converted back to result" do
            read_result = Transform::Read.(text, :json, result.class)

            assert(read_result == result)
          end
        end
      end
    end
  end
end
