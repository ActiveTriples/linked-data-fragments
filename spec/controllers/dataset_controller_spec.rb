require 'rails_helper'

describe DatasetController do
  describe 'index' do
    context 'JSON-LD' do
      before { get :index, :format => :jsonld }

      it 'should return a graph' do
        expect(JSON::LD::Reader.new(response.body)).not_to be_empty
      end

      it 'should be JSON-LD' do
        expect(response.content_type).to eq 'application/ld+json'
      end
    end

    context 'n-triples' do
      before { get :index, :format => :nt }

      it 'should return a graph' do
        expect(RDF::NTriples::Reader.new(response.body)).not_to be_empty
      end

      it 'should be n-triples' do
        expect(response.content_type).to eq 'application/n-triples'
      end
    end

    context "ttl" do
      before { get :index, :format => :ttl }

      it 'should return a graph' do
        expect(RDF::Turtle::Reader.new(response.body)).not_to be_empty
      end

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
    it do
      get :show, id: 'lcsh', format: :nt
    end
  end
end
