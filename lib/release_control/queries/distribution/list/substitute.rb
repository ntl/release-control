module ReleaseControl
  module Queries
    module Distribution
      class List
        module Substitute
          def self.build
            List.new
          end

          class List
            attr_accessor :result

            def call
              result || Result.new
            end

            def set(result)
              self.result = result
            end
          end
        end
      end
    end
  end
end
