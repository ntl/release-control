module ReleaseControl
  module Controls
    module Queries
      module Distribution
        module List
          module Result
            def self.example
              release = Release.example
              alternate_release = Release::Alternate.example

              result = ReleaseControl::Queries::Distribution::List::Result.new
              result.set(release.suite, release)
              result.set(alternate_release.suite, alternate_release)
              result
            end
          end
        end
      end
    end
  end
end
