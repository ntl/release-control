require_relative '../../automated_init'

context "Release Command" do
  context "Substitute" do
    context "Released Predicate" do
      context "Actuated" do
        source_archive = Controls::SourceArchive::Filename.example

        distribution = Controls::Distribution.example

        logger = Log.build('test')

        substitute = Dependency::Substitute.build(Commands::Release)

        deb_file = substitute.(source_archive, distribution, logger: logger)

        test "Returns debian file" do
          assert(File.extname(deb_file) == '.deb')
        end

        context "No Argument" do
          test "Returns true" do
            assert(substitute.released?)
          end
        end

        context "Argument" do
          context "Matches source archive" do
            test "Returns true" do
              assert(substitute.released?(source_archive))
            end
          end

          context "Does not match source archive" do
            other_source_archive = 'other-source-archive.tar.gz'

            test "Returns false" do
              refute(substitute.released?(other_source_archive))
            end
          end
        end

        context "Block Given" do
          test "Distribution is passed to block" do
            dist = nil

            substitute.released? { |_, d| dist = d }

            assert(dist == distribution)
          end

          test "Logger is passed to block" do
            actuated_logger = nil

            substitute.released? { |_, _, l| actuated_logger = l }

            assert(actuated_logger == logger)
          end

          context "Block evaluates to true" do
            test "Returns true" do
              assert(substitute.released? { true })
            end
          end

          context "Block evaluates to false" do
            test "Returns false" do
              refute(substitute.released? { false })
            end
          end
        end
      end

      context "Not Actuated" do
        substitute = Dependency::Substitute.build(Commands::Release)

        context "No Argument" do
          test "Returns false" do
            refute(substitute.released?)
          end
        end
      end
    end
  end
end
