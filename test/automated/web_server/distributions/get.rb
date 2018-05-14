require_relative '../web_server_init'

context "Web Server" do
  context "Distributions Resource" do
    context "GET Request" do
      driver, web_server = Controls::WebServer::Driver.example(include: :web_server)

      control_result = Controls::Queries::Distribution::List::Result.example

      web_server.get_distributions.set(control_result)

      driver.get '/distributions'

      response_body = driver.last_response.body

      puts response_body

      context "Response Body" do
        test "Valid JSON" do
          refute proc { JSON.parse(response_body) } do
            raises_error?(JSON::ParserError)
          end
        end

        test do
          result = Transform::Read.(response_body, :json, control_result.class)

          assert(result == control_result)
        end
      end
    end
  end
end
