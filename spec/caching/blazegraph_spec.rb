require 'rails_helper'

RSpec.describe LinkedDataFragments::Blazegraph do
  subject {
    allow(Setting).to receive(:cache_backend).and_return('blazegraph')
    allow(Setting).to receive(:cache_backend_url).and_return('http://localhost:8988/blazegraph/sparql')
    allow(Setting).to receive(:cache_backend_context).and_return('http://localhost:8988/linked-data-fragments-test')
    LinkedDataFragments::Blazegraph.new
  }

  after do
    subject.delete_all
  end

  context "retrieve a subject uri", :vcr do
    it "should be configured as a Blazegraph instance with the mocked uri" do
      expect(subject).to be_instance_of LinkedDataFragments::Blazegraph
      expect(subject.cache_backend_url).to eq "http://localhost:8988/blazegraph/sparql"
      expect(subject.cache_backend_context).to eq "http://localhost:8988/linked-data-fragments-test"
    end

    it "should retrieve and return a response on a valid subject uri" do
      expect(subject.retrieve('http://dbpedia.org/resource/Berlin').dump(:ttl)).to match /http\:\/\/dbpedia.org\/resource\/Category\:Berlin/
    end

=begin
    it "should retrieve nothing on an invalid uri" do
      expect(subject.retrieve('http://dbpedia.org/resource/BerlinInvalidAndNotReal')).to be_empty
    end
=end
  end
end
