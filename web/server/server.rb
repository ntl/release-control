module ReleaseControl
  class WebServer < Sinatra::Base
    dependency :get_distributions, Queries::Distribution::List

    attr_accessor :distributions
    attr_accessor :components
    attr_accessor :architectures

    def configure
      Queries::Distribution::List.configure(self)
      Settings.set(self, strict: false)
    end

    def self.build(app)
      app.configure
      super
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
    end

    get '/distributions' do
      configured_distributions = get_distributions.()

      JSON.pretty_generate({
        :list => configured_distributions,

        :configure => {
          :distributions => distributions,
          :components => components,
          :architectures => architectures
        }
      })
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
