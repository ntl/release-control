module ReleaseControl
  class WebServer < Sinatra::Base
    include SinatraExtensions::Dependencies

    dependency :get_repository, Repository::Get

    dependency :copy_package, Commands::CopyPackage
    dependency :remove_package, Commands::RemovePackage
    dependency :release_package, Commands::Release
    dependency :publish_package, Packaging::Debian::Repository::S3::Commands::Package::Publish

    setting :component

    def configure
      Repository::Get.configure(self)

      Commands::CopyPackage.configure(self)
      Commands::RemovePackage.configure(self)
      Commands::Release.configure(self)
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

    post '/packages' do
      tmpdir = Dir.mktmpdir

      file_basename = params[:file][:filename]
      file_data = params[:file][:tempfile]
      file_content_type = params[:file][:type]

      distribution = params[:distribution]

      path = File.join(tmpdir, file_basename)

      File.open(path, 'w') do |file|
        file.write(file_data.read) until file_data.eof?
      end

      case file_content_type
      when ContentType.debian_package
        publish_package.(path, distribution: distribution, component: component)
      when ContentType.source_archive
        release_package.(path, distribution)
      end

      201

    ensure
      File.unlink(path) if File.exist?(path)
      Dir.delete(tmpdir) if File.directory?(tmpdir)
    end

    post '/copy-package' do
      package, version, source_distribution, target_distribution =
        params.values_at('package', 'version', 'sourceDistribution', 'targetDistribution')

      copy_package.(package, version, source_distribution, target_distribution)

      201
    end

    post '/remove-package' do
      package, version, distribution = params.values_at('package', 'version', 'distribution')

      remove_package.(package, version, distribution)

      201
    end

    get '/controls/repository' do
      require 'release_control/controls'

      repository = ReleaseControl::Controls::Repository.example

      Transform::Write.(repository, :json)
    end

    module ContentType
      def self.debian_package
        'application/x-deb'
      end

      def self.source_archive
        'application/gzip'
      end
    end
  end
end
