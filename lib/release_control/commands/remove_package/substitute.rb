module ReleaseControl
  module Commands
    class RemovePackage
      module Substitute
        def self.build
          RemovePackage.new
        end

        class RemovePackage
          def call(package, version, distribution)
            record = Record.new(package, version, distribution)

            records << record

            record
          end

          def removed?(&block)
            if block.nil?
              records.any?
            else
              records.any? do |record|
                block.(*record.to_a)
              end
            end
          end

          def records
            @records ||= []
          end

          Record = Struct.new(:package, :version, :distribution)
        end
      end
    end
  end
end

