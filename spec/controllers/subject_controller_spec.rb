require 'rails_helper'

describe SubjectController do
  let(:uri) { 'http://dbpedia.org/resource/Berlin' }

  describe '.cache_service' do
    it 'defaults be set to a valid service with a retrieve method' do
      expect(SubjectController.cache_service).to respond_to :retrieve
    end
  end

  describe '#cache_service' do
    it 'defaults be set to a valid service with a retrieve method' do
      expect(subject.cache_service).to respond_to :retrieve
    end
  end

  describe '#subject', :vcr => { cassette_name: 'dbpedia' }do
    after { SubjectController.cache_service.delete_all! }

    ApplicationController.renderer_mapping.each do |format, _|
      context "with #{format} format" do
        let(:reader) { RDF::Reader.for(file_extension: format.to_s) }

        before { get :subject, { subject: uri, format: format } }

        it 'gives a graph in the response body' do
          expect(reader.new(response.body)).not_to be_empty
        end

        it 'responds with be correct content type' do
          expect(response.content_type)
            .to eq Mime::Type.lookup_by_extension(format).to_s
        end
        
        it 'adds content to the cache backend' do
          expect(subject.cache_service).not_to be_empty
        end
      end
    end

    context 'with invalid format', :vcr do
      it 'raises 404 Routing Error with valid response formats' do
        expect { get :subject, { subject: uri, format: :invalid } }
          .to raise_error(ActionController::RoutingError,
                          /[ttl].+[application\/ld\+json]/)
      end
    end

    context 'with named dataset' do
      let(:format)  { :ttl }
      let(:dataset) { 'lcsh' }

      let(:dataset_uri) do
        LinkedDataFragments::DatasetBuilder.for(name: dataset).to_term
      end

      it 'gives a graph in the response body' do
        get :subject, { subject: uri, format: format, dataset: dataset }
        
        expect(RDF::Reader.for(format).new(response.body).statements)
          .not_to be_empty
      end

      it 'adds content to cache backend for dataset' do
        get :subject, { subject: uri, format: format, dataset: dataset }
        
        expect(subject.cache_service.empty?(context: dataset_uri)).to be false
      end

      it 'does not add content to other datasets' do
        get :subject, { subject: uri, format: format, dataset: dataset }
        
        expect(subject.cache_service.empty?).to be true
      end
    end
  end
end
