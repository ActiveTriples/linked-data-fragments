require 'spec_helper'

require 'linked_data_fragments/builders'

describe LinkedDataFragments::ControlBuilder do
  subject { described_class.new(control, property) }

  let(:control)  { "subject" }
  let(:property) { RDF.subject }

  describe '#control' do
    it { expect(subject.control).to eq control }
  end

  describe '#property' do
    it { expect(subject.property).to eq property }
  end

  describe "#build" do
    let(:result) { subject.build }

    it "should return a control with a variable" do
      expect(result.variable).to contain_exactly control
    end

    it "should return a control with a property" do
      expect(result.property).to contain_exactly property
    end
  end
end
