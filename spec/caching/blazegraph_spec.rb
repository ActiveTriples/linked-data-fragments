require 'rails_helper'

RSpec.describe LinkedDataFragments::Blazegraph do
  subject {
    Setting.stub(:cache_backend_url).and_return('http://localhost:8988/blazegraph/sparql')
    LinkedDataFragments::Blazegraph.new
  }

  after do
    subject.delete_all
  end

  context "retrieve a subject uri", :vcr do
    it "should retrieve and return a response on a valid subject uri" do
      expect(subject.retrieve('http://dbpedia.org/resource/Berlin').dump(:ttl)).to match /http\:\/\/dbpedia.org\/resource\/Category\:Berlin/
    end

    it "should retrieve nothing on an invalid uri" do
      expect(subject.retrieve('http://dbpedia.org/resource/BerlinInvalidAndNotReal')).to be_empty
    end
  end
end
