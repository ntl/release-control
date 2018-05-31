module ReleaseControl
  module Commands
    class CopyPackage
      module Substitute
        def self.build
          CopyPackage.new
        end

        class CopyPackage
          def call(package, version, source_distribution, target_distribution)
            record = Record.new(package, version, source_distribution, target_distribution)

            records << record

            record
          end

          def copied?(&block)
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

          Record = Struct.new(:package, :version, :source_distribution, :target_dsitribution)
        end
      end
    end
  end
end
