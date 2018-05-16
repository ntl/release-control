module ReleaseControl
  module Controls
    module Distribution
      def self.example
        'some-distribution'
      end

      module Alternate
        def self.example
          'other-distribution'
        end
      end

      module List
        def self.example
          [
            Distribution.example,
            Alternate.example
          ]
        end

        def self.set
          Set.new(example)
        end
      end
    end
  end
end
