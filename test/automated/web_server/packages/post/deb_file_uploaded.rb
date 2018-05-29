require_relative '../../web_server_init'

context "Web Server" do
  context "Packages" do
    context "POST Request" do
      context "Debian package file is uploaded" do
        agent, web_server = Controls::WebServer::Agent.example(include: :web_server)

        distribution = Controls::Distribution.example

        component = Controls::Component.example
        web_server.component = component

        uploaded_file = Controls::WebServer::UploadedFile::DebianPackage.example

        data = {
          :distribution => distribution,
          :file => uploaded_file
        }

        response = agent.post "/packages", data

        publish_package = web_server.publish_package

        test "Returns 201 Created" do
          assert(response.status == 201)
        end

        test "Publishes package" do
          published = publish_package.published? do |local_path|
            File.basename(local_path) == uploaded_file.original_filename
          end

          assert(published)
        end

        test "Distribution" do
          published = publish_package.published? do |_, dist|
            dist == distribution
          end

          assert(published)
        end

        test "Component" do
          published = publish_package.published? do |_, _, comp|
            comp == component
          end

          assert(published)
        end
      end
    end
  end
end
