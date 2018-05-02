module ReleaseControl
  module JSON
    def self.write(raw_data)
      json_formatted_data = Casing::Underscore.(raw_data)
      json_formatted_data = Casing::Camel.(json_formatted_data)

      ::JSON.pretty_generate(json_formatted_data)
    end

    def self.read(text)
      json_formatted_data = ::JSON.parse(text, symbolize_names: true)

      Casing::Underscore.(json_formatted_data)
    end
  end
end
