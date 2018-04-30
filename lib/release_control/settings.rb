module ReleaseControl
  class Settings < ::Settings
    def self.data_source
      'settings/release_control.json'
    end

    def self.set(receiver)
      instance = build
      instance.set(receiver)
    end
  end
end
