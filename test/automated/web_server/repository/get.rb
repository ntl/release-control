require_relative '../web_server_init'

context "Web Server" do
  context "Repository Resource" do
    context "GET Request" do
      driver, web_server = Controls::WebServer::Driver.example(include: :web_server)

      repository = Controls::Repository.example

      web_server.get_repository.set(repository)

      response = driver.get '/repository'

      context "Response Body" do
        test "Valid JSON" do
          refute proc { JSON.parse(response.body) } do
            raises_error?(JSON::ParserError)
          end
        end

        test do
          response_data = JSON.parse(response.body)
          control_data = Controls::Repository::JSON.data

          assert(response_data == control_data)
        end
      end
    end
  end
end
