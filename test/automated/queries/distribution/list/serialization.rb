require_relative '../../../automated_init'

context "Queries" do
  context "Distribution" do
    context "List" do
      context "Serialization" do
        control_result = Controls::Queries::Distribution::List::Result.example

        context "JSON Text" do
          text = Transform::Write.(control_result, :json)

          test "Valid JSON" do
            refute proc { JSON.parse(text) } do
              raises_error?
            end
          end
        end
      end
    end
  end
end
