require_relative '../../web_server_init'

context "Web Server" do
  context "Packages" do
    context "POST Request" do
      context "Source archive file is uploaded" do
        agent, web_server = Controls::WebServer::Agent.example(include: :web_server)

        distribution = Controls::Distribution.example

        component = Controls::Component.example
        web_server.component = component

        uploaded_file = Controls::WebServer::UploadedFile::SourceArchive.example

        data = {
          :distribution => distribution,
          :file => uploaded_file
        }

        response = agent.post "/packages", data

        test "Returns 201 Created" do
          assert(response.status == 201)
        end

        release_package = web_server.release_package

        test "Releases package generated from source archive" do
          released = release_package.released? do |path, *|
            File.basename(path) == uploaded_file.original_filename
          end

          assert(released)
        end

        test "Distribution" do
          released = release_package.released? do |dist|
            dist == distribution
          end
        end

        test "Component" do
          released = release_package.released? do |_, comp|
            comp == component
          end
        end
      end
    end
  end
end
