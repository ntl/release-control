require_relative '../../automated_init'

context "Repository" do
  context "Get" do
    distributions = Controls::Distribution::List.example
    component = Controls::Component.example
    architecture = Controls::Architecture.example

    get_repository = Repository::Get.new

    get_repository.distributions = distributions
    get_repository.component = component
    get_repository.architecture = architecture

    repository = get_repository.()

    test "Returns repository" do
      assert(repository.instance_of?(Repository))
    end

    context "Repository" do
      context "Distributions" do
        distributions.each do |distribution|
          context "Distribution: #{distribution}" do
            test "Included in repository" do
              assert(repository.distribution?(distribution))
            end
          end
        end
      end

      context "Packages" do
        test "Empty" do
          assert(repository.packages.empty?)
        end
      end
    end
  end
end
