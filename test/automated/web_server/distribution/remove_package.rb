require_relative '../../automated_init'

context "Web Server" do
  context "Distribution Resource" do
    context "Copy Package" do
      agent, web_server = Controls::WebServer::Agent.example(include: :web_server)

      package = Controls::Package.package
      version = Controls::Package.version

      distribution = Controls::Distribution.example

      data = {
        :package => package,
        :version => version,
        :distribution => distribution
      }

      response = agent.post "/remove-package", data

      remove_package = web_server.remove_package

      test "Returns 201 created" do
        assert(response.status == 201)
      end

      test "Package is removed from source distribution" do
        removed = remove_package.removed? do |_package, _version, _distribution|
          _package == package && _version == version && _distribution == distribution
        end

        assert(removed)
      end
    end
  end
end
