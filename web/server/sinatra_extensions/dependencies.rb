module ReleaseControl
  module SinatraExtensions
    module Dependencies
      def self.included(cls)
        cls.class_exec do
          extend Build
          extend Dependency

          virtual :configure
        end
      end

      # Sinatra duplicates the application and performs each request on the
      # clone. This is so that endpoints can assign instance variables
      # without contaminating other request/response cycles. Dependencies
      # are generally nil-coalescing (e.g. `@some_dependency ||= ...`), so
      # they must be reified before we perform requests.
      def call(_)
        Dependency.reify_dependencies(self)

        super
      end

      module Build
        def build(app)
          app.configure

          super
        end
      end

      module Dependency
        def dependency(*)
          attr = super

          self.dependency_registry << attr

          attr
        end

        def dependency_registry
          @dependency_registry ||= Set.new
        end

        def self.reify_dependencies(instance)
          cls = instance.class

          cls.dependency_registry.each do |attr|
            instance.public_send(attr)
          end
        end
      end
    end
  end
end
