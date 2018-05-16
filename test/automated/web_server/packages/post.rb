require_relative '../web_server_init'

context "Web Server" do
  context "Packages" do
    context "POST Request" do
      agent, web_server = Controls::WebServer::Agent.example(include: :web_server)

      component = Controls::Component.example
      web_server.component = component

      deb_file = Controls::Package.filename
      data = 'some-deb-file'

      response = agent.post "/packages/#{deb_file}", data

      test "Returns 201 Created" do
        assert(response.status == 201)
      end

      test "Publishes package to component" do
        publish_package = web_server.publish_package

        published = publish_package.published? do |local_path, c|
          File.basename(local_path) == deb_file && c == component
        end

        assert(published)
      end
    end
  end
end
