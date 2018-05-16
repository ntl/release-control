require_relative '../../automated_init'

context "Repository" do
  context "Get" do
    context "Substitute" do
      context "Repository Set" do
        substitute = Dependency::Substitute.build(Repository::Get)

        control_repository = Controls::Repository.example

        substitute.set(control_repository)

        repository = substitute.()

        test "Returns repository that was set" do
          assert(repository == control_repository)
        end
      end

      context "Repository Not Set" do
        substitute = Dependency::Substitute.build(Repository::Get)

        repository = substitute.()

        test "Returns nothing" do
          assert(repository.nil?)
        end
      end
    end
  end
end
