module ReleaseControl
  class Repository
    module Transform
      def self.json
        JSON
      end

      def self.raw_data(instance)
        data = {}

        distributions = instance.distributions.each_value.sort do |a, b|
          a.name <=> b.name
        end

        distributions = distributions.map do |distribution|
          distribution_data = distribution.to_h

          packages = distribution_data.delete(:packages)

          packages = packages.each_value.sort do |a, b|
            a.name <=> b.name
          end

          packages = packages.map do |package|
            versions = package.versions.to_a.sort do |a, b|
              compare_versions(b, a)
            end

            { :name => package.name, :versions => versions }
          end

          distribution_data.delete_if { |k, v| v.nil? }

          distribution_data[:packages] = packages unless packages.empty?

          date = distribution_data.delete(:date)
          distribution_data[:date] = Clock.iso8601(date) unless date.nil?

          valid_until = distribution_data.delete(:valid_until)
          distribution_data[:valid_until] = Clock.iso8601(valid_until) unless valid_until.nil?

          distribution_data
        end

        data[:distributions] = distributions unless distributions.empty?

        packages = instance.packages.each_value.sort do |a, b|
          a.name <=> b.name
        end

        packages = packages.map do |package|
          versions = package.versions.each_value.sort do |a, b|
            compare_versions(b.value, a.value)
          end

          versions = versions.map do |version|
            distributions = version.distributions.sort

            version_data = version.to_h

            version_data.delete_if { |k, v| v.nil? }

            value = version_data.delete(:version)

            version_data.delete(:package)

            version_data.update({
              :value => value,
              :distributions => distributions
            })

            version_data
          end

          { :name => package.name, :versions => versions }
        end

        data[:packages] = packages

        data
      end

      def self.compare_versions(v1, v2)
        Gem::Version.new(v1) <=> Gem::Version.new(v2)
      end

      module JSON
        def self.write(raw_data)
          formatted_data = Casing::Camel.(raw_data)

          ::JSON.pretty_generate(formatted_data)
        end
      end
    end
  end
end
