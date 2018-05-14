require_relative '../../../automated_init'

context "Queries" do
  context "Distribution" do
    context "List" do
      get_distributions = Queries::Distribution::List.new

      component = Controls::Component.example
      architecture = Controls::Architecture.example

      get_distributions.distributions = ['dist-1', 'dist-2', 'dist-3']
      get_distributions.component = component
      get_distributions.architecture = architecture

      get_object = get_distributions.get_object

      configured_release_text = Controls::Release::Text::Signed.example
      get_object.add("dists/dist-1/InRelease", configured_release_text)

      other_configured_release_text = Controls::Release::Alternate::Text::Signed.example
      get_object.add("dists/dist-3/InRelease", other_configured_release_text)

      package_index_store = get_distributions.package_index_store

      configured_package_index = Controls::PackageIndex.example
      package_index_store.add(
        configured_package_index,
        distribution: 'dist-1',
        component: component,
        architecture: architecture
      )

      result = get_distributions.()

      test "Returns result" do
        refute(result.nil?)
      end

      test "Returns distributions which have already been configured" do
        control_distribution = Controls::Distribution.example(name: 'dist-1')

        assert(result['dist-1'] == control_distribution)
        refute(result['dist-3'].nil?)
      end

      test "Initializes distributions that have not yet been configured" do
        control_distribution = ReleaseControl::Distribution.new
        control_distribution.name = 'dist-2'
        control_distribution.component = component
        control_distribution.architecture = architecture

        assert(result['dist-2'] == control_distribution)
      end
    end
  end
end
