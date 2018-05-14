require_relative './automated_init'

context "Settings" do
  cls = Class.new do
    setting :distributions
    setting :component
    setting :architecture
  end

  receiver = cls.new

  ReleaseControl::Settings.set(receiver)

  test "Distributions is set" do
    refute(receiver.distributions.nil?)
  end

  test "Component is set" do
    refute(receiver.component.nil?)
  end

  test "Architecture is set" do
    refute(receiver.architecture.nil?)
  end
end
