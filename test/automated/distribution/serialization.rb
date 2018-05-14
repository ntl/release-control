require_relative '../automated_init'

context "Distribution" do
  context "Serialization" do
    control_distribution = Controls::Distribution.example

    name = control_distribution.name or fail
    architecture = control_distribution.architecture or fail
    component = control_distribution.component or fail
    date = control_distribution.date or fail
    description = control_distribution.description or fail
    origin = control_distribution.origin or fail
    label = control_distribution.label or fail
    version = control_distribution.version or fail

    json_text = Transform::Write.(control_distribution, :json)

    parsed_json = JSON.parse(json_text, symbolize_names: true)

    raw_data = Casing::Underscore.(parsed_json)

    context "Attributes" do
      test "Name" do
        assert(raw_data[:name] == name)
      end

      test "Architecture" do
        assert(raw_data[:architecture] == architecture)
      end

      test "Component" do
        assert(raw_data[:component] == component)
      end

      test "Date is converted to ISO8601" do
        assert(raw_data[:date] == Clock.iso8601(date))
      end

      test "Description" do
        assert(raw_data[:description] == description)
      end

      test "Origin" do
        assert(raw_data[:origin] == origin)
      end

      test "Label" do
        assert(raw_data[:label] == label)
      end

      test "Version" do
        assert(raw_data[:version] == version)
      end

      context "Package Index" do
        package_index_data = raw_data[:package_index]
        package_index = Transform::Read.instance(package_index_data, Packaging::Debian::Schemas::PackageIndex)

        test do
          assert(package_index == Controls::PackageIndex.example)
        end
      end
    end
  end
end
