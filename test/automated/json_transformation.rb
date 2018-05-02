require_relative './automated_init'

context "JSON Transformation" do
  control_text = <<~JSON.chomp
    {
      "someUnderscoreKey": "some value",
      "someString": "other value"
    }
  JSON

  context "Converting to JSON text" do
    data = {
      :some_underscore_key => 'some value',
      'SOMEString' => 'other value'
    }

    test "Serializes into formatted camel cased JSON" do
      text = ReleaseControl::JSON.write(data)

      assert(text == control_text)
    end
  end

  context "Converting back to raw data" do
    control_data = {
      :some_underscore_key => 'some value',
      :some_string => 'other value'
    }

    test "Casing is normalized" do
      raw_data = ReleaseControl::JSON.read(control_text)

      assert(raw_data == control_data)
    end
  end
end
