module ReleaseControl
  class Repository
    class Get
      module Substitute
        def self.build
          Get.new
        end

        class Get
          attr_accessor :repository

          def set(repository)
            self.repository = repository
          end

          def call
            repository
          end
        end
      end
    end
  end
end
