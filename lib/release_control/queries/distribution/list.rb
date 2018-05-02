module ReleaseControl
  module Queries
    module Distribution
      class List
        include Log::Dependency

        configure :get_distributions

        dependency :get_object, AWS::S3::Client::Object::Get

        setting :distributions
        setting :components
        setting :architectures

        def configure
          Settings.set(self)
          AWS::S3::Client::Object::Get.configure(self)
        end

        def self.build
          instance = new
          instance.configure
          instance
        end

        def self.call
          instance = build
          instance.()
        end

        def call
          logger.trace { "Getting list of distributions (Distributions Setting: #{distributions * ', '})" }

          result = Result.new

          distributions.each do |distribution|
            object_key = in_release_path(distribution)

            release_text = get_object.(object_key)

            unless release_text.nil?
              release = Transform::Read.(release_text, :rfc822_signed, Packaging::Debian::Repository::S3::Release)
            else
              release = new_release(distribution)
            end

            result[distribution] = release
          end

          logger.debug { "Get list of distributions done (Distributions: #{distributions * ', '})" }

          result
        end

        def new_release(distribution)
          release = Packaging::Debian::Schemas::Release.new
          release.components = self.components
          release.architectures = self.architectures
          release
        end

        def in_release_path(distribution)
          File.join('dists', distribution, 'InRelease')
        end

        class Result
          include Schema::DataStructure

          attribute :distributions, Hash, default: proc { Hash.new }

          def set(distribution, release)
            self.distributions[distribution] = release
          end
          alias_method :[]=, :set

          def get(distribution)
            self.distributions[distribution]
          end
          alias_method :[], :get

          module Transform
            def self.json
              JSON
            end

            def self.raw_data(instance)
              list = {}

              instance.distributions.each do |distribution, release|
                data = ::Transform::Write.raw_data(release)

                list[distribution] = data
              end

              { :list => list }
            end

            def self.instance(raw_data)
              list = raw_data.fetch(:list)

              result = Result.new

              list.each do |distribution, attributes|
                release = ::Transform::Read.instance(
                  attributes,
                  Packaging::Debian::Schemas::Release
                )

                result[distribution.to_s] = release
              end

              result
            end

            module JSON
              def self.write(raw_data)
                list = raw_data[:list]

                list.each do |distribution, attributes|
                  attributes.keys.each do |key|
                    next unless key.is_a?(Symbol)

                    if attributes[key].nil?
                      attributes.delete(key)
                    else
                      formatted_key = Casing::Camel.(key, symbol_to_string: true)

                      attributes[formatted_key] = attributes.delete(key)
                    end
                  end
                end

                ::JSON.pretty_generate(raw_data)
              end

              def self.read(text)
                json_formatted_data = ::JSON.parse(text, symbolize_names: true)

                Casing::Underscore.(json_formatted_data)
              end
            end
          end
        end
      end
    end
  end
end
