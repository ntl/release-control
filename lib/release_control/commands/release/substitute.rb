module ReleaseControl
  module Commands
    class Release
      module Substitute
        def self.build
          Release.new
        end

        class Release
          def call(source_archive, distribution, logger: nil)
            record = Record.new(source_archive, distribution, logger)

            records << record

            basename = File.basename(source_archive, '.tar.gz')

            File.join(
              File.dirname(source_archive),
              "#{basename}.deb"
            )
          end

          def released?(source_archive=nil, &block)
            block ||= proc { true }

            if source_archive.nil?
              predicate = proc { |record| block.(record.to_a) }
            else
              return false unless records.any? { |record| record.source_archive == source_archive }

              predicate = proc { |record| block.(record.distribution, record.logger) }
            end

            records.any?(&predicate)
          end

          def records
            @records ||= []
          end

          Record = Struct.new(:source_archive, :distribution, :logger)
        end
      end
    end
  end
end
