require 'spec_helper'

require 'rack/test'
require 'linked_data_fragments/repository'
require 'linked_data_fragments/cache_server'

describe LinkedDataFragments::CacheServer do
  include Rack::Test::Methods

  let(:app) { described_class::APPLICATION }

  let(:reader) do
    RDF::Reader.for(content_type: last_response.headers['Content-Type'])
      .new(last_response.body)
  end

  before do
    # @todo: REMOVE THIS HACKY STUB
    allow(LinkedDataFragments::Settings)
      .to receive(:cache_backend)
      .and_return(:repository)
  end

  describe '/' do
    before { get '/' }

    it 'gives 2xx response' do
      expect(last_response).to be_ok
    end

    it 'returns a dataset' do
      expect(reader).to have_object RDF::Vocab::VOID.Dataset
    end

    it 'returns the root dataset' do
      expect(reader)
        .to have_subject LinkedDataFragments::DatasetBuilder.new.build.to_uri
    end
  end
  
  describe '/dataset/:dataset' do
    let(:dataset_name) { 'lcsh' }
    let(:path)         { "/dataset/#{dataset_name}" }

    let(:dataset_uri) do
      LinkedDataFragments::DatasetBuilder
        .for(name: dataset_name).to_term
    end

    before { get path }
   
    it 'gives 2xx response' do
      expect(last_response).to be_ok
    end

    it 'returns a dataset' do
      expect(reader).to have_object RDF::Vocab::VOID.Dataset
    end

    it 'returns the root dataset' do
      expect(reader.subjects).to include dataset_uri
    end
  end

  describe '/{?subject}', vcr: { cassette_name: 'dbpedia' } do
    let(:uri) { 'http://dbpedia.org/resource/Berlin' }

    it 'returns 2xx status' do
      get "/?subject=#{uri}"

      expect(last_response).to be_ok
    end

    it 'returns the requested resource' do
      get "/?subject=#{uri}"
      
      expect(reader).to have_subject RDF::URI(uri)
    end
  end

  describe '/dataset/:dataset/{?subject}', vcr: { cassette_name: 'dbpedia' } do
    let(:dataset_name) { 'lcsh' }
    let(:path)         { "/dataset/#{dataset_name}" }
    let(:uri)          { 'http://dbpedia.org/resource/Berlin' }

    it 'returns 2xx status' do
      get "#{path}?subject=#{uri}"

      expect(last_response).to be_ok
    end

    it 'returns the requested resource' do
      get "#{path}/?subject=#{uri}"
      
      expect(reader).to have_subject RDF::URI(uri)
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
