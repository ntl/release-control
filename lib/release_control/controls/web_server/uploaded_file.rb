module ReleaseControl
  module Controls
    module WebServer
      module UploadedFile
        def self.example(filename: nil, contents: nil, content_type: nil)
          filename ||= self.filename
          contents ||= self.contents
          content_type ||= self.content_type

          tmpdir = Dir.mktmpdir

          at_exit { FileUtils.rm_rf(tmpdir) }

          path = File.join(tmpdir, filename)

          File.open(path, 'w') do |file|
            Rack::Test::UploadedFile.new(file.path, content_type)
          end
        end

        def self.filename
          'some-file.txt'
        end

        def self.contents
          %{some-data\n}
        end

        def self.content_type
          'text/plain'
        end

        module DebianPackage
          def self.example
            UploadedFile.example(filename: filename, contents: contents, content_type: content_type)
          end

          def self.filename
            Package.filename
          end

          def self.contents
            path = Packaging::Debian::Package::Controls::Package.example

            File.read(path)
          end

          def self.content_type
            'application/x-deb'
          end
        end

        module SourceArchive
          def self.example
            UploadedFile.example(filename: filename, contents: contents, content_type: content_type)
          end

          def self.filename
            Controls::SourceArchive::Filename.example
          end

          def self.contents
            Controls::SourceArchive.data
          end

          def self.content_type
            'application/gzip'
          end
        end
      end
    end
  end
end
