require 'spec_helper'

require 'linked_data_fragments/builders'

describe LinkedDataFragments::DatasetBuilder do
  subject { described_class.new(**opts) }

  let(:opts) { {} }

  describe '#build' do
    let(:result) { subject.build }

    it 'assigns uri endpoint' do
      expect(result.uri_lookup_endpoint)
        .to contain_exactly(subject.uri_endpoint.to_s)
    end

    it 'has the appropriate subject' do
      expect(result.rdf_subject).to eq RDF::URI(subject.uri_root) / '#dataset'
    end

    it 'has a search endpoint with a template' do
      expect(result.search.first.template.first)
        .to eq subject.uri_endpoint.to_s
    end

    it 'has a search endpoint with mappings' do
      expect(result.search.first.mapping.first.property)
        .to contain_exactly(RDF.subject)
    end

    context 'with values' do
      let(:opts) do
        { uri_endpoint: template, uri_root: root, control_mapping: mapping }
      end

      let(:mapping)  { { 'object' => RDF.object } }
      let(:root)     { 'http://example.com/my_dataset/' }
      let(:template) { LinkedDataFragments::HydraTemplate.new( "#{root}{?object}") }

      it 'has the paramaterized endpoint' do
        expect(result.uri_lookup_endpoint).to contain_exactly template.to_s
      end

      it 'has the paramaterized subject' do
        expect(result.rdf_subject).to eq RDF::URI(root) / '#dataset'
      end

      it 'has a search endpoint with the paramaterized template' do
        expect(result.search.first.template)
          .to contain_exactly(template.to_s)
      end

      it 'has a search endpoint with parameterized mappings' do
        expect(result.search.first.mapping.first.property)
          .to contain_exactly(RDF.object)
      end
    end
  end

  describe '#uri_endpoint' do
    it 'defaults to configured value' do
      expect(subject.uri_endpoint.to_s)
        .to eq LinkedDataFragments::Settings.uri_endpoint
    end

    it 'default manifests as HydraTemplate instance' do
      expect(subject.uri_endpoint)
        .to be_a LinkedDataFragments::HydraTemplate
    end
  end

  describe '#uri_root' do
    it 'defaults to the configured value' do
      expect(subject.uri_root).to eq LinkedDataFragments::Settings.uri_root
    end
  end
end
