require 'rails_helper'

RSpec.describe Dataset do
  subject { described_class.new(uri) }
  let(:uri) { "http://localhost:3000#dataset" }

  describe "#type" do
    it "should be a hydra collection" do
      expect(subject.type).to include RDF::URI("http://www.w3.org/ns/hydra/core#Collection")
    end
    it "should be a dataset" do
      expect(subject.type).to include RDF::URI("http://rdfs.org/ns/void#Dataset")
    end
  end
  
  it "should apply the dataset schema" do
    DatasetSchema.properties.each do |property|
      expect(subject.class.properties[property.name.to_s].predicate).to eq property.predicate
    end
  end
end
