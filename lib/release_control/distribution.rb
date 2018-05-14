module ReleaseControl
  class Distribution
    include Schema::DataStructure

    attribute :name, String
    attribute :architecture, String
    attribute :component, String

    attribute :date, Time

    attribute :description, String
    attribute :origin, String
    attribute :label, String
    attribute :version, String

    attribute :package_index, Packaging::Debian::Schemas::PackageIndex

    module Transform
      def self.json
        JSON
      end

      def self.raw_data(instance)
        data = instance.to_h

        if date = data.delete(:date)
          data[:date] = Clock.iso8601(date)
        end

        if package_index = data.delete(:package_index)
          package_index_data = ::Transform::Write.raw_data(package_index)

          data[:package_index] = package_index_data
        end

        data
      end
    end
  end
end
