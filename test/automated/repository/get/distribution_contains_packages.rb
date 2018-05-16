require_relative '../../automated_init'

context "Repository" do
  context "Get" do
    context "Distribution Contains Packages" do
      distribution = Controls::Distribution.example
      component = Controls::Component.example
      architecture = Controls::Architecture.example

      get_repository = Repository::Get.new

      get_repository.distributions = [distribution]
      get_repository.component = component
      get_repository.architecture = architecture

      package_index_store = get_repository.package_index_store

      package_index = Controls::PackageIndex.example
      package_index_store.add(
        package_index,
        distribution: distribution,
        component: component,
        architecture: architecture
      )

      repository = get_repository.()

      refute(repository.nil?)

      context "Packages Section" do
        packages = repository.packages

        context "Contains each package from package index" do
          package_index.each do |control_package|
            identifier = "#{control_package.name} (#{control_package.version})"

            context "Package: #{identifier}" do
              test "Added to repository" do
                assert(repository.package?(control_package.name, version: control_package.version))
              end

              package_version = repository.get_package(control_package.name, version: control_package.version)

              context "Attributes" do
                test "Distributions" do
                  assert(package_version.distributions.include?(distribution))
                end

                Repository::Package::Version.attribute_names.each do |attribute|
                  next if attribute == :distributions

                  test "#{attribute}" do
                    control_value = control_package.public_send(attribute)
                    refute(control_value.nil?)

                    value = package_version.public_send(attribute)

                    assert(value == control_value)
                  end
                end
              end
            end
          end
        end
      end

      context "Distributions Section" do
        dist = repository.get_distribution(distribution)
        refute(dist.nil?)

        package_name = Controls::Package.package

        test "Contains package" do
          assert(dist.package?(package_name))
        end

        test "Includes version" do
          package = dist.get_package(package_name)

          assert(package.versions.include?(Controls::Package.version))
        end
      end
    end
  end
end
