require 'rails_helper'

RSpec.describe Result do
  subject { described_class.new(root_uri) }
  let(:root_uri) { "http://localhost:3000" }
  describe "#rdf_subject" do
    it "should be the passed URI" do
      expect(subject.rdf_subject).to eq RDF::URI(root_uri)
    end
  end
  
  describe "#type" do
    it "should be a hydra collection" do
      expect(subject.type).to include RDF::URI("http://www.w3.org/ns/hydra/core#Collection")
    end
    it "should be a paged collection" do
      expect(subject.type).to include RDF::URI("http://www.w3.org/ns/hydra/core#PagedCollection")
    end
  end

  it "should apply the Result schema" do
    LinkedDataFragments::ResultSchema.properties.each do |property|
      expect(subject.class.properties[property.name.to_s].predicate).to eq property.predicate
    end
  end
end
