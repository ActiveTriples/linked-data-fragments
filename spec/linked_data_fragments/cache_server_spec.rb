require 'spec_helper'

require 'rack/test'
require 'linked_data_fragments/repository'
require 'linked_data_fragments/cache_server'

describe LinkedDataFragments::CacheServer do
  include Rack::Test::Methods

  let(:app) { described_class::APPLICATION }

  before do
    # @todo: REMOVE THIS HACKY STUB
    allow(LinkedDataFragments::Settings)
      .to receive(:cache_backend)
      .and_return(:repository)
  end

  describe '/' do
    it 'returns a dataset' do
      get '/'

      expect(last_response).to be_ok
      expect(last_response.body).to include '#Dataset'
    end
  end
  
  describe '/endpoint', :vcr do
    let(:uri) { 'http://dbpedia.org/resource/Berlin' }

    it 'accesses cache' do
      get "/subject?subject=#{uri}"

      expect(last_response).to be_ok
    end
  end

  describe '/other_routes' do
    it 'returns 404' do
      get '/other_routes'

      expect(last_response).not_to be_ok
      expect(last_response.status).to eq 404
    end
  end
end
