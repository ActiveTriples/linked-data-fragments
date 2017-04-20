require 'rails_helper'

RSpec.describe DatasetBuilder do
  subject { described_class.new }

  describe "#uri_endpoint" do
    it "should default to configured value" do
      expect(subject.uri_endpoint.to_s).to eq Setting.uri_endpoint
    end
  end

  describe "#uri_root" do
    it "should default to the configured value" do
      expect(subject.uri_root).to eq Setting.uri_root
    end
  end

  describe "#build" do
    let(:result) { subject.build }
    it "should assign uri endpoint" do
      expect(result.uri_lookup_endpoint).to eq [Setting.uri_endpoint.to_s]
    end
    it "should have the appropriate subject" do
      expect(result.rdf_subject).to eq RDF::URI(Setting.uri_root)
    end
    it "should have a search endpoint with a template" do
      expect(result.search.first.template.first).to eq Setting.uri_endpoint
    end

    it "should have a search endpoint with mappings" do
      expect(result.search.first.mapping.first.property).to eq [RDF.subject]
    end
  end
end