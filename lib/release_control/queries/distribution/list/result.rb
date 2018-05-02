module ReleaseControl
  module Queries
    module Distribution
      class List
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
              distributions = []

              instance.distributions.each do |_, release|
                data = ::Transform::Write.raw_data(release)

                distributions << data
              end

              { :distributions => distributions }
            end

            def self.instance(raw_data)
              distributions = raw_data.fetch(:distributions)

              result = Result.new

              distributions.each do |data|
                release = ::Transform::Read.instance(
                  data,
                  Packaging::Debian::Schemas::Release
                )

                result[release.suite] = release
              end

              result
            end
          end
        end
      end
    end
  end
end
