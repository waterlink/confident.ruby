module Confident
  RSpec.describe Result do
    let(:value) { double("Value") }
    let(:error) { double("Error object") }

    describe ".new" do
      it "can't be called" do
        expect { Result.new(value) }.to raise_error(NoMethodError)
      end

      it "can't be called in :[] form" do
        expect { Result[value] }.to raise_error(NoMethodError)
      end
    end

    describe ".from_condition" do
      subject { Result.from_condition(condition_value) }

      context "when the condition is true" do
        let(:condition_value) { true }

        it "returns Result::Ok" do
          expect(subject).to be_ok
        end
      end

      context "when the condition is false" do
        let(:condition_value) { false }

        it "returns Result::Error" do
          expect(subject.on_error { |e| [:report, e] }.unwrap).to eq([:report, Confident::Result::DEFAULT_FAILURE_MESSAGE])
        end

        context "when failure_message is provided" do
          subject { Result.from_condition(condition_value, failure_message) }
          let(:failure_message) { "Special failure message" }

          it "return Result::Error with provided failure message" do
            expect(subject.on_error { |e| [:report, e] }.unwrap).to eq([:report, failure_message])
          end
        end
      end
    end

    describe ".ok" do
      subject { Result.ok(value) }

      it "returns instance of Result::Ok" do
        is_expected.to be_a(Result::Ok)
      end
    end

    describe ".error" do
      subject { Result.error(error) }

      it "returns instance of Result::Error" do
        is_expected.to be_a(Result::Error)
      end
    end

    describe Result::Ok do
      subject { Result.ok(value) }

      describe "#ok?" do
        it "is true" do
          expect(subject.ok?).to be_truthy
        end
      end

      describe "#unwrap" do
        context "when error callback was not provided" do
          it "raises error" do
            expect { subject.unwrap }.to raise_error(Result::MissingErrorHandler)
          end
        end

        context "when error callback is provided" do
          subject { super().on_error { |e| :do_nothing } }

          it "returns a wrapped value" do
            expect(subject.unwrap).to eq(value)
          end
        end
      end
    end

    describe Result::Error do
      subject { Result.error(error) }

      describe "#ok?" do
        it "is false" do
          expect(subject.ok?).to be_falsey
        end
      end

      describe "#unwrap" do
        context "when error callback is not provided" do
          it "raises error" do
            expect { subject.unwrap }.to raise_error(Result::MissingErrorHandler)
          end
        end

        context "when error callback is provided" do
          subject { super().on_error { |e| [:report, e] } }

          it "executes callback and returns its result" do
            expect(subject.unwrap).to eq([:report, error])
          end
        end
      end

    end
  end
end
