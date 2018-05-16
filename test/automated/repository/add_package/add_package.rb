require_relative '../../automated_init'

context "Repository" do
  context "Add Package" do
    repository = Repository.new

    name = Controls::Package.package
    version = Controls::Package.version
    distributions = Controls::Distribution::List.example

    package = repository.add_package(name, version, distributions)

    test "Package is returned" do
      assert(package.instance_of?(Repository::Package))
    end

    test "Package is added" do
      assert(repository.packages[name] == package)
    end

    test "Name" do
      assert(package.name == name)
    end

    context "Versions" do
      test "One is added" do
        assert(package.versions.count == 1)
      end

      context "Added Version" do
        added_version = package.get_version(version)

        test "Value" do
          assert(added_version.value == version)
        end

        test "Distributions" do
          assert(added_version.distributions == Controls::Distribution::List.set)
        end
      end
    end

    context "Distributions" do
      test "Initialized for each value given" do
        assert(repository.distributions.count == distributions.count)
      end

      test "Each distribution includes package" do
        distributions.each do |distribution_name|
          distribution = repository.get_distribution(distribution_name)

          refute(distribution.nil?)

          assert(distribution.package?(name))
        end
      end
    end
  end
end
