require 'spec_helper'

require 'linked_data_fragments/service'
require 'linked_data_fragments/repository'

describe LinkedDataFragments::Service do
  subject { described_class.instance }
  
  before do
    # @todo: REMOVE THIS HACKY STUB
    allow(LinkedDataFragments::Settings)
      .to receive(:cache_backend)
      .and_return(:repository)
  end

  describe '#cache' do
    it 'gives a backend' do
      expect(subject.cache).to respond_to :retrieve
    end
  end
end
