module ReleaseControl
  class Settings < ::Settings
    def self.data_source
      'settings/release_control.json'
    end

    def self.instance
      @instance ||= build
    end

    def self.set(receiver, *namespace, **args)
      instance.set(receiver, *namespace, **args)
    end

    def self.get(*namespace)
      instance.get(*namespace)
    end
  end
end
