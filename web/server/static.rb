module ReleaseControl
  class WebServer
    class Static < Sinatra::Base
      include SinatraExtensions::Dependencies

      set :static, true
      set :public_folder, File.expand_path('../client/build', __dir__)

      use Rack::Auth::Basic, 'Protected Area' do |username, password|
        http_username = Settings.get(:http_username)
        http_password = Settings.get(:http_password)

        username == http_username && password == http_password
      end

      get '/' do
        index_html = File.join(settings.public_folder, 'index.html')

        content_type 'text/html'

        send_file index_html
      end
    end
  end
end
