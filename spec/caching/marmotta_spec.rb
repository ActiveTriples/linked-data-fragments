require 'rails_helper'

RSpec.describe LinkedDataFragments::Marmotta do
  subject {
    Setting.stub(:cache_backend).and_return('marmotta')
    Setting.stub(:cache_backend_url).and_return('http://localhost:8988/marmotta')
    Setting.stub(:cache_backend_context).and_return('http://localhost:8988/linked-data-fragments-test')
    LinkedDataFragments::Marmotta.new
  }

  after do
    subject.delete_all
  end

  context "retrieve a subject uri", :vcr do
    it "should be configured as a Marmotta instance with the mocked uri" do
      expect(subject).to be_instance_of LinkedDataFragments::Marmotta
      expect(subject.cache_backend_url).to eq "http://localhost:8988/marmotta"
      expect(subject.cache_backend_context).to eq "http://localhost:8988/linked-data-fragments-test"
    end
    it "should retrieve and return a response on a valid subject uri" do
      expect(subject.retrieve('http://dbpedia.org/resource/Berlin').dump(:ttl)).to match /http\:\/\/dbpedia.org\/resource\/Category\:Berlin/
    end

    it "should retrieve nothing on an invalid uri" do
      expect(subject.retrieve('http://dbpedia.org/resource/BerlinInvalidAndNotReal')).to be_empty
    end
  end
end
