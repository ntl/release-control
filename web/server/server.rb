module ReleaseControl
  class WebServer < Sinatra::Base
    set :static, true

    helpers do
      def inflector
        @inflecton ||= Dry::Inflector.new
      end
    end

    get '/' do
      @configured_distributions = Queries::Distribution::List.()

      @distributions = Settings.get(:distributions)
      @components = Settings.get(:components)
      @architectures = Settings.get(:architectures)

      headers['Access-Control-Allow-Origin'] = '*'

      JSON.generate([{ name: 'release' }, { name: 'prerelease' }])
    end

    post '/distributions' do
      distribution = params['distribution']

      release_store = Packaging::Debian::Repository::S3::Release::Store.build(distribution)

      release = Packaging::Debian::Schemas::Release.build
      release.suite = distribution
      release.label = params['label']
      release.components = Set.new(params['components'])
      release.architectures = Set.new(params['architectures'])
      release.codename = params['codename']

      release_store.put(release)

      redirect '/'
    end
  end
end
