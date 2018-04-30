require_relative './automated_init'

context "Settings" do
  cls = Class.new do
    setting :distributions
    setting :components
    setting :architectures
  end

  receiver = cls.new

  settings = ReleaseControl::Settings.build

  settings.set(receiver)

  test "Distributions is set" do
    refute(receiver.distributions.nil?)
  end

  test "Components is set" do
    refute(receiver.components.nil?)
  end

  test "Architectures is set" do
    refute(receiver.architectures.nil?)
  end
end
