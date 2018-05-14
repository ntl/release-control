module ReleaseControl
  module Queries
    module Distribution
      class List
        class Result
          include Schema::DataStructure

          attribute :distributions, Array, default: proc { Array.new }

          def add(distribution)
            self.distributions << distribution
          end

          def get(name)
            self.distributions.find do |distribution|
              distribution.name == name
            end
          end
          alias_method :[], :get

          module Transform
            def self.json
              JSON
            end

            def self.raw_data(instance)
              distributions = []

              instance.distributions.each do |distribution|
                raw_data = ::Transform::Write.raw_data(distribution)

                distributions << distribution
              end

              { :distributions => distributions }
            end
          end
        end
      end
    end
  end
end
