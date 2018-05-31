require_relative '../automated_init'

context "Remove Package" do
  context "Substitute" do
    context "Removed" do
      substitute = Dependency::Substitute.build(Commands::RemovePackage)

      control_package = Controls::Package.package
      control_version = Controls::Package.version
      control_distribution = Controls::Distribution.example

      substitute.(control_package, control_version, control_distribution)

      context "Predicate Method" do
        context "No arguments" do
          test "Returns true" do
            assert(substitute.removed?)
          end
        end

        context "Block argument given" do
          test "Package name is passed to block" do
            package = nil

            substitute.removed? { |p| package = p }

            assert(package == control_package)
          end

          test "Version is passed to block" do
            version = nil

            substitute.removed? { |_, v| version = v }

            assert(version == control_version)
          end

          test "Distribution is passed to block" do
            distribution = nil

            substitute.removed? { |_, _, d| distribution = d }

            assert(distribution == control_distribution)
          end

          context "Block evaluates to true" do
            test "Returns true" do
              assert(substitute.removed? { true })
            end
          end

          context "Block evaluates to false" do
            test "Returns false" do
              refute(substitute.removed? { false })
            end
          end
        end
      end
    end

    context "Not Removed" do
      substitute = Dependency::Substitute.build(Commands::RemovePackage)

      context "Predicate Method" do
        context "No arguments" do
          test "Returns false" do
            refute(substitute.removed?)
          end
        end
      end
    end
  end
end
