require 'rails_helper'

RSpec.describe ControlBuilder do
  subject { described_class.new(control, property) }
  let(:control) { "subject" }
  let(:property) { RDF.subject }

  describe "#build" do
    let(:result) { subject.build }
    it "should return a control with a variable" do
      expect(result.variable).to eq [control]
    end
    it "should return a control with a property" do
      expect(result.property).to eq [property]
    end
  end
end
