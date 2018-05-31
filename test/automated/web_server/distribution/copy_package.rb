require_relative '../../automated_init'

context "Web Server" do
  context "Distribution Resource" do
    context "Copy Package" do
      agent, web_server = Controls::WebServer::Agent.example(include: :web_server)

      package = Controls::Package.package
      version = Controls::Package.version

      source_distribution = Controls::Distribution.example
      target_distribution = Controls::Distribution::Alternate.example

      data = {
        'package' => package,
        'version' => version,
        'sourceDistribution' => source_distribution,
        'targetDistribution' => target_distribution
      }

      response = agent.post "/copy-package", data

      copy_package = web_server.copy_package

      test "Returns 201 created" do
        assert(response.status == 201)
      end

      test "Package is copied from source distribution to target distribution" do
        copied = copy_package.copied? do |_package, _version, _source_dist, _target_dist|
          _package == package && _version == version && _source_dist == source_distribution && _target_dist == target_distribution
        end

        assert(copied)
      end
    end
  end
end
