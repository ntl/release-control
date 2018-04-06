require 'sinatra'

module BuildControl
  class WebServer < Sinatra::Base
    set :static, true
    set :public_folder, File.join(settings.root, 'static')
    set :views, File.join(settings.root, 'templates')

    get '/' do
      erb :root
    end
  end

  Tilt.register(Tilt::ERBTemplate, 'html.erb')
end
