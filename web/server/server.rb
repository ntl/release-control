module ReleaseControl
  class WebServer < Sinatra::Base
    extend SinatraExtensions::Configure

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
    end

    get '/distributions' do
      JSON.pretty_generate({
        :list => [],

        :configure => {
          :distributions => [],
          :components => [],
          :architectures => []
        }
      })
    end
  end
end
