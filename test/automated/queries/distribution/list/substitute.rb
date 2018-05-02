require_relative '../../../automated_init'

context "Queries" do
  context "Distribution" do
    context "List" do
      context "Substitute" do
        context "Result Is Set" do
          substitute = Dependency::Substitute.build(Queries::Distribution::List)

          control_result = Queries::Distribution::List::Result.new

          substitute.set(control_result)

          result = substitute.()

          test "Result that was set is returned" do
            assert(result.eql?(control_result))
          end
        end

        context "No Result Set" do
          substitute = Dependency::Substitute.build(Queries::Distribution::List)

          result = substitute.()

          test "Returns empty result set" do
            assert(result == Queries::Distribution::List::Result.new)
          end
        end
      end
    end
  end
end
