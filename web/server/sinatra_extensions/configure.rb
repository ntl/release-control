module ReleaseControl
  module SinatraExtensions
    module Configure
      def self.extended(cls)
        cls.instance_exec do
          def build(app)
            app.configure
            super
          end

          def configure
          end
        end
      end
    end
  end
end
