require_relative '../../../automated_init'

context "Queries" do
  context "Distribution" do
    context "List" do
      get_distributions = Queries::Distribution::List.new

      components = Controls::Release.components
      architectures = Controls::Release.architectures

      get_distributions.distributions = ['dist-1', 'dist-2', 'dist-3']
      get_distributions.components = components
      get_distributions.architectures = architectures

      get_object = get_distributions.get_object

      configured_release_text = Controls::Release::Text::Signed.example
      get_object.add("dists/dist-1/InRelease", configured_release_text)

      other_configured_release_text = Controls::Release::Alternate::Text::Signed.example
      get_object.add("dists/dist-3/InRelease", other_configured_release_text)

      result = get_distributions.()

      test "Returns result" do
        refute(result.nil?)
      end

      test "Returns distributions which have already been configured" do
        assert(result['dist-1'] == Controls::Release.example)
        assert(result['dist-3'] == Controls::Release::Alternate.example)
      end

      test "Initializes distributions that have not yet been configured" do
        control_release = Packaging::Debian::Schemas::Release.new
        control_release.components = Set.new(components)
        control_release.architectures = Set.new(architectures)

        assert(result['dist-2'] == control_release)
      end
    end
  end
end
