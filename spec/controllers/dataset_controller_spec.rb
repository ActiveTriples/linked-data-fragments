require 'rails_helper'

describe DatasetController do
  shared_examples 'a valid RDF response' do
    it 'gives a graph in the body' do
      reader = RDF::Reader.for(content_type: response.content_type)

      expect(reader.new(response.body)).not_to be_empty
    end
  end

  describe 'index' do
    context 'JSON-LD' do
      before { get :index, :format => :jsonld }
      
      it_behaves_like 'a valid RDF response'

      it 'should be JSON-LD' do
        expect(response.content_type).to eq 'application/ld+json'
      end
    end

    context 'n-triples' do
      before { get :index, :format => :nt }

      it_behaves_like 'a valid RDF response'

      it 'should be n-triples' do
        expect(response.content_type).to eq 'application/n-triples'
      end
    end

    context "ttl" do
      before { get :index, :format => :ttl }

      it 'should be n-triples' do
        expect(response.content_type).to eq 'text/turtle'
      end
    end

    context 'invalid' do
      it 'should be of type 404 Routing Error' do
        expect { get :index, format: :invalid}
          .to raise_error(ActionController::RoutingError)
      end

      it 'should output valid response formats' do
        expect { get :index, format: :invalid}
          .to raise_error(ActionController::RoutingError,
                          /[ttl].+[application\/ld\+json]/)
      end
    end
  end

  describe 'show' do
    context 'n-triples' do
      let(:name) { 'lcsh' }

      before { get :show, id: name, format: :nt }

      it_behaves_like 'a valid RDF response'

      it 'returns the requested dataset' do
        reader = RDF::Reader.for(content_type: response.content_type)

        expect(reader.new(response.body))
          .to have_subject RDF::URI('http://localhost:3000/dataset/lcsh#dataset')
      end
    end
  end
end
