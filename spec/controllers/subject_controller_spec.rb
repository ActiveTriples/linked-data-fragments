require 'rails_helper'

describe SubjectController do
  let(:uri) { 'http://dbpedia.org/resource/Berlin' }

  describe 'settings' do
    context '#cache_service' do
      it 'defaults be set to a valid service with a retrieve method' do
        expect(SubjectController.cache_service.respond_to?(:retrieve)).to eq true
      end
    end
  end

  describe '#subject' do
    ApplicationController.renderer_mapping.each do |format, _|
      context "with #{format} format", :vcr do
        let(:reader) { RDF::Reader.for(file_extension: format.to_s) }

        before { get :subject, { subject: uri, format: format } }

        it 'gives a graph in the response body' do
          expect(reader.new(response.body)).not_to be_empty
        end

        it 'responds with be correct content type' do
          expect(response.content_type)
            .to eq Mime::Type.lookup_by_extension(format).to_s
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
  end
end
