require_relative '../../automated_init'

context "Repository" do
  context "Get" do
    context "Release Attributes" do
      distribution = Controls::Distribution.example
      component = Controls::Component.example
      architecture = Controls::Architecture.example

      get_repository = Repository::Get.new

      get_repository.distributions = [distribution]
      get_repository.component = component
      get_repository.architecture = architecture

      release_store = get_repository.release_store

      release = Controls::Release.example
      release_store.add(release, distribution)

      repository = get_repository.()

      refute(repository.nil?)

      context "Distribution Entry" do
        dist = repository.get_distribution(distribution)
        refute(dist.nil?)

        context "Attributes" do
          test "Packages" do
            assert(dist.packages.empty?)
          end

          test "Name (copied from suite)" do
            assert(dist.name == release.suite)
          end

          Repository::Distribution.attribute_names.each do |attribute|
            next if [:name, :packages].include?(attribute)

            test "#{attribute}" do
              control_value = release.public_send(attribute)

              value = dist.public_send(attribute)

              assert(value == control_value)
            end
          end
        end
      end
    end
  end
end
