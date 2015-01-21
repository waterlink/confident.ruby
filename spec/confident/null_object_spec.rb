module Confident
  RSpec.describe NullObject do
    it "quacks with self" do
      expect(subject.quack).to be(subject)
    end
  end

  RSpec.describe AutoNullObject do
    describe "#[]" do
      subject { AutoNullObject[value] }

      context "when value is not nil" do
        let(:value) { double("A value") }

        it "returns original value" do
          is_expected.to be(value)
        end
      end

      context "when value is nil" do
        let(:value) { nil }

        it "returns NullObject" do
          is_expected.to be_a(NullObject)
        end
      end
    end
  end
end
