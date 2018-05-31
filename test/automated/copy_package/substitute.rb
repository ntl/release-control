require_relative '../automated_init'

context "Copy Package" do
  context "Substitute" do
    context "Copied" do
      substitute = Dependency::Substitute.build(Commands::CopyPackage)

      control_package = Controls::Package.package
      control_version = Controls::Package.version

      source_distribution = Controls::Distribution.example
      target_distribution = Controls::Distribution::Alternate.example

      substitute.(control_package, control_version, source_distribution, target_distribution)

      context "Predicate Method" do
        context "No arguments" do
          test "Returns true" do
            assert(substitute.copied?)
          end
        end

        context "Block argument given" do
          test "Package name is passed to block" do
            package = nil

            substitute.copied? { |p| package = p }

            assert(package == control_package)
          end

          test "Version is passed to block" do
            version = nil

            substitute.copied? { |_, v| version = v }

            assert(version == control_version)
          end

          test "Source distribution is passed to block" do
            distribution = nil

            substitute.copied? { |_, _, d| distribution = d }

            assert(distribution == source_distribution)
          end

          test "Target distribution is passed to block" do
            distribution = nil

            substitute.copied? { |_, _, _, d| distribution = d }

            assert(distribution == target_distribution)
          end

          context "Block evaluates to true" do
            test "Returns true" do
              assert(substitute.copied? { true })
            end
          end

          context "Block evaluates to false" do
            test "Returns false" do
              refute(substitute.copied? { false })
            end
          end
        end
      end
    end

    context "Not Copied" do
      substitute = Dependency::Substitute.build(Commands::CopyPackage)

      context "Predicate Method" do
        context "No arguments" do
          test "Returns false" do
            refute(substitute.copied?)
          end
        end
      end
    end
  end
end
