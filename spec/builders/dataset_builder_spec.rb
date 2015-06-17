require 'rails_helper'

RSpec.describe DatasetBuilder do
  subject { described_class.new }

  describe "#uri_endpoint" do
    it "should default to configured value" do
      expect(subject.uri_endpoint).to eq Setting.uri_endpoint
    end
  end

  describe "#root_uri" do
    it "should default to the configured value" do
      expect(subject.root_uri).to eq Setting.root_uri
    end
  end

  describe "#build" do
    let(:result) { subject.build }
    it "should assign uri endpoint" do
      expect(result.uri_lookup_endpoint).to eq [Setting.uri_endpoint.to_s]
    end
    it "should have the appropriate subject" do
      expect(result.rdf_subject).to eq RDF::URI(Setting.root_uri)
    end
    it "should have a search endpoint with a template" do
      expect(result.search.first.template.first).to eq Setting.uri_endpoint
    end
  end
end
