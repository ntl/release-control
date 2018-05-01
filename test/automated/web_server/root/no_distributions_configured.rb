require_relative '../web_server_init'

context "Web Server" do
  context "Root Endpoint" do
    context "No Distributions Configured" do
      driver, web_server = Controls::WebServer::Driver.example(include: :web_server)

      get_object = web_server.get_object

      binding.irb
    end
  end
end
