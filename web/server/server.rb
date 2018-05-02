module ReleaseControl
  class WebServer < Sinatra::Base
    extend SinatraExtensions::Configure

    dependency :get_distributions, Queries::Distribution::List

    def configure
      Queries::Distribution::List.configure(Self)
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

      content_type :json
    end

    get '/distributions' do
      result = get_distributions.()

      Transform::Write.(result, :json)
    end
  end
end
