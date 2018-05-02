module ReleaseControl
  module Controls
    Distribution = Packaging::Debian::Repository::S3::Controls::Distribution

    module Distribution
      module List
        def self.example
          [Distribution.example, Alternate.example]
        end
      end
    end
  end
end
