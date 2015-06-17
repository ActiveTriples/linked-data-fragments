require 'rails_helper'

RSpec.describe HydraTemplate do
  subject { described_class.new(template) }
  let(:template) { "http://localhost:4000/{?subject}" }

  describe "#controls" do
    it "should return the mapped controls" do
      expect(subject.controls).to eq ["subject"]
    end
    context "when given multiple controls" do
      let(:template) { "http://localhost:4000/{?subject,predicate, object}" }
      it "should return all of them" do
        expect(subject.controls).to eq ["subject", "predicate", "object"]
      end
    end
    context "with no controls" do
      let(:template) { "http://localhost:4000" }
      it "should return an empty array" do
        expect(subject.controls).to eq []
      end
    end
    context "with slashes to separate controls" do
      let(:template) { "http://localhost:4000/{subject}/{predicate}" }
      it "should return them" do
        expect(subject.controls).to eq ["subject", "predicate"]
      end
    end
  end
end
