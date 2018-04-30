require_relative '../../automated_init'

context "Queries" do
  context "Distribution" do
    context "List" do
      get_distributions = Queries::Distribution::List.new

      get_distributions.distributions = ['dist-1', 'dist-2', 'dist-3']

      get_object = get_distributions.get_object

      in_release_text = Controls::Release::Text::Signed.example

      get_object.add("dists/dist-1/InRelease", in_release_text)
      get_object.add("dists/dist-3/InRelease", in_release_text)

      distributions = get_distributions.()

      test "Returns hash" do
        assert(distributions.instance_of?(Hash))
      end

      test "Returns distributions which have already been initialized" do
        assert(distributions.keys == ['dist-1', 'dist-3'])
      end

      test "Returns release data" do
        control_release = Controls::Release.example

        assert(distributions['dist-1'] == control_release)
        assert(distributions['dist-3'] == control_release)
      end
    end
  end
end
