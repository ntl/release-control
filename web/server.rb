module ReleaseControl
  class WebServer < Sinatra::Base
    set :static, true
    set :public_folder, File.join(settings.root, 'static')
    set :views, File.join(settings.root, 'templates')

    get '/' do
      @distributions = Queries::Distribution::List.()

      erb :index
    end
  end

  Tilt.register(Tilt::ERBTemplate, 'html.erb')
end
