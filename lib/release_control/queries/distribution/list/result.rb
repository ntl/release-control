module ReleaseControl
  module Queries
    module Distribution
      class List
        class Result
          include Schema::DataStructure

          attribute :distributions, Hash, default: proc { Hash.new }

          def set(distribution, release)
            self.distributions[distribution] = release
          end
          alias_method :[]=, :set

          def get(distribution)
            self.distributions[distribution]
          end
          alias_method :[], :get

          module Transform
            def self.json
              JSON
            end

            def self.raw_data(instance)
              list = {}

              instance.distributions.each do |distribution, release|
                data = ::Transform::Write.raw_data(release)

                list[distribution] = data
              end

              { :list => list }
            end

            def self.instance(raw_data)
              list = raw_data.fetch(:list)

              result = Result.new

              list.each do |distribution, attributes|
                release = ::Transform::Read.instance(
                  attributes,
                  Packaging::Debian::Schemas::Release
                )

                result[distribution.to_s] = release
              end

              result
            end
          end
        end
      end
    end
  end
end
