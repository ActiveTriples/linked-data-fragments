require 'rails_helper'

RSpec.describe Template do
  subject { described_class.new(uri) }
  let(:uri) { RDF::Node.new("triplePattern") }

  it "should apply the template schema" do
    LinkedDataFragments::TemplateSchema.properties.each do |property|
      expect(subject.class.properties[property.name.to_s].predicate).to eq property.predicate
    end
  end
end
