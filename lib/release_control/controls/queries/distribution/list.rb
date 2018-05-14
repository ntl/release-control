module ReleaseControl
  module Controls
    module Queries
      module Distribution
        module List
          module Result
            def self.example
              distribution = Controls::Distribution.example

              alternate_distribution = Controls::Distribution::Alternate.example

              result = ReleaseControl::Queries::Distribution::List::Result.new
              result.add(distribution)
              result.add(alternate_distribution)
              result
            end
          end
        end
      end
    end
  end
end
