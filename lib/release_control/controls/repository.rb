module ReleaseControl
  module Controls
    module Repository
      def self.example
        repository = ReleaseControl::Repository.new

        repository.add_distribution('some-distribution') do |distribution|
          distribution.description = "Example distribution"
          distribution.date = Time::Raw.example
        end

        repository.add_distribution('other-distribution') do |distribution|
          distribution.description = "Example distribution (other)"
          distribution.date = Time::Raw.example
        end

        repository.add_package('some-package', '1.1.1', ['some-distribution', 'other-distribution']) do |package|
          package.section = 'some-section'
          package.description = 'Example package (older version)'
          package.depends = 'some-older-dependency'
        end

        repository.add_package('some-package', '2.2.2', ['some-distribution']) do |package|
          package.section = 'some-section'
          package.description = 'Example package (current version)'
          package.depends = 'some-dependency'
        end

        repository.add_package('other-package', '1.1.1', ['other-distribution']) do |package|
          package.section = 'other-section'
          package.description = 'Example package (other)'
          package.depends = 'other-dependency'
        end

        repository.add_package('current-package', '1.1.1', ['some-distribution', 'other-distribution']) do |package|
          package.section = 'current-package-section'
          package.description = 'Example package (current)'
          package.depends = 'current-package-dependency'
        end

        repository.add_package('current-package', '2.2.2', ['some-distribution', 'other-distribution']) do |package|
          package.section = 'current-package-section'
          package.description = 'Example package (current)'
          package.depends = 'current-package-dependency'
        end

        repository
      end
    end
  end
end
