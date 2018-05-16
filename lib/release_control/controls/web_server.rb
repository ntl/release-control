module ReleaseControl
  module Controls
    module WebServer
      def self.example
        ReleaseControl::WebServer.new!
      end

      module Driver
        def self.example(include: nil)
          web_server = WebServer.example

          mock_session = Rack::MockSession.new(web_server)

          driver = Rack::Test::Session.new(mock_session)

          return driver if include.nil?

          include = Array(include)

          return_values = [driver]

          Array(include).each do |return_attr|
            case return_attr
            when :web_server
              return_values << web_server
            else
              raise ArgumentError, "Cannot return `#{return_attr.inspect}'"
            end
          end

          return *return_values
        end
      end
    end
  end
end
