module ReleaseControl
  class WebServer < Sinatra::Base
    include SinatraExtensions::Dependencies

    dependency :get_repository, Repository::Get
    dependency :publish_package, Packaging::Debian::Repository::S3::Commands::Package::Publish

    setting :component

    def configure
      Repository::Get.configure(self)
      Packaging::Debian::Repository::S3::Commands::Package::Publish.configure(self)

      Settings.set(self)
    end

    set :static, true

    helpers do
      def inflector
        @inflector ||= Dry::Inflector.new
      end
    end

    before do
      headers({
        'Access-Control-Allow-Origin' => '*'
      })

      content_type 'application/json'
    end

    get '/repository' do
      repository = get_repository.()

      Transform::Write.(repository, :json)
    end

    post '/packages/:deb_file' do
      tmpdir = Dir.mktmpdir

      path = File.join(tmpdir, params[:deb_file])

      File.open(path, 'w') do |file|
        file.write(request.body.read) until request.body.eof?
      end

      publish_package.(path, component: component)

      201

    ensure
      File.unlink(path) if File.size?(path)
      Dir.delete(tmpdir) if File.directory?(tmpdir)
    end

    get '/controls/repository' do
      require 'release_control/controls'

      repository = ReleaseControl::Controls::Repository.example

      Transform::Write.(repository, :json)
    end
  end
end
