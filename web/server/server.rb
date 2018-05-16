module ReleaseControl
  class WebServer < Sinatra::Base
    extend SinatraExtensions::Configure

    dependency :get_repository, Repository::Get

    def configure
      Repository::Get.configure(self)
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
  end
end
