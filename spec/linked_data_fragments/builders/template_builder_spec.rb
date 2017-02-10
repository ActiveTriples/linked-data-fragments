require 'spec_helper'

require 'linked_data_fragments/builders'

describe LinkedDataFragments::TemplateBuilder do
  subject { described_class.new(node, template) }
  
  let(:node)     { LinkedDataFragments::Dataset.new }
  let(:template) { 'http://localhost:4000/{?subject}' }
  
  describe '#build' do
    it 'builds a template with the node as parent' do
      expect(subject.build.parent).to eql node
    end

    it 'sets #template to on built template' do
      expect(subject.build.template).to contain_exactly template
    end
  end

  describe '#dataset_node' do
    it { expect(subject.dataset_node).to eql node }
  end

  describe '#uri_template' do
    it { expect(subject.uri_template).to eql template }
  end
end
