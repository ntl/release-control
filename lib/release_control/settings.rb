module ReleaseControl
  class Settings < ::Settings
    def self.data_source
      'settings/release_control.json'
    end

    def self.instance
      @instance ||= build
    end

    def self.set(receiver)
      instance.set(receiver)
    end

    def self.get(setting)
      instance.get(setting)
    end
  end
end
