require 'spec_helper'

require 'linked_data_fragments/builders'

describe LinkedDataFragments::DatasetBuilder do
  subject { described_class.new }

  describe '#build' do
    let(:result) { subject.build }

    it 'should assign uri endpoint' do
      expect(result.uri_lookup_endpoint)
        .to eq [LinkedDataFragments::Settings.uri_endpoint.to_s]
    end

    it 'should have the appropriate subject' do
      expect(result.rdf_subject)
        .to eq RDF::URI(LinkedDataFragments::Settings.uri_root)
    end

    xit 'should have a search endpoint with a template' do
      expect(result.search.first.template.first)
        .to eq LinkedDataFragments::Setting.uri_endpoint
    end

    xit 'should have a search endpoint with mappings' do
      expect(result.search.first.mapping.first.property)
        .to eq [RDF.subject]
    end
  end

  describe '#uri_endpoint' do
    it 'should default to configured value' do
      expect(subject.uri_endpoint.to_s)
        .to eq LinkedDataFragments::Settings.uri_endpoint
    end
  end

  describe '#uri_root' do
    it 'should default to the configured value' do
      expect(subject.uri_root).to eq LinkedDataFragments::Settings.uri_root
    end
  end
end
