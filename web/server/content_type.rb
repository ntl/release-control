module ReleaseControl
  class WebServer
    module ContentType
      def self.debian_package
        'application/x-deb'
      end

      def self.source_archive
        'application/gzip'
      end

      def self.json
        'application/json'
      end
    end
  end
end
