require 'rails_helper'

RSpec.describe SubjectController do

  describe "settings" do
    #FIXME
    context "#cache_service" do
      it "should default be set to a valid service with a retrieve method" do
        expect(SubjectController.cache_service.respond_to?(:retrieve)).to eq true
      end
    end

    context "#routing" do
      it "should correctly return the subject route for various uri endpoints" do

        allow(Setting).to receive(:config).and_return({uri_endpoint: 'http://localhost:3000/{?subject}'})
        expect(Setting.uri_endpoint_route).to eq '/*subject'

        allow(Setting).to receive(:config).and_return({uri_endpoint: 'http://localhost:3000/subject/{?subject}'})
        expect(Setting.uri_endpoint_route).to eq '/subject/*subject'

        allow(Setting).to receive(:config).and_return({uri_endpoint: 'https://localhost:3000/long/a/{?subject}'})
        expect(Setting.uri_endpoint_route).to eq '/long/a/*subject'

        allow(Setting).to receive(:config).and_return({uri_endpoint: 'https://www.example.com:8888/fds/a/{?subject}'})
        expect(Setting.uri_endpoint_route).to eq '/fds/a/*subject'

      end

      it 'should error on an incorrect uri_endpoint setting' do
        #No http
        allow(Setting).to receive(:config).and_return({uri_endpoint: 'www.example.com:8888/fds/a/{?subject}'})
        expect{Setting.uri_endpoint_route}.to raise_error(ArgumentError)

        #No ending slash
        allow(Setting).to receive(:config).and_return({uri_endpoint: 'http://localhost:3000{?subject}'})
        expect{Setting.uri_endpoint_route}.to raise_error(ArgumentError)
      end
    end

  end

  describe "subject" do

    context "JSON-LD", :vcr do
      before do
        get :subject, {:subject => 'http://dbpedia.org/resource/Berlin',:format => :jsonld}
      end
      it "should return a graph" do
        expect(JSON::LD::Reader.new(response.body).statements.to_a.length).not_to eq 0
      end
      it "should be JSON-LD" do
        expect(response.content_type).to eq "application/ld+json"
      end
    end

    context "n-triples", :vcr do
      before do
        get :subject, {:subject => 'http://dbpedia.org/resource/Berlin', :format => :nt}
      end
      it "should return a graph" do
        expect(RDF::NTriples::Reader.new(response.body).statements.to_a.length).not_to eq 0
      end
      it "should be n-triples" do
        expect(response.content_type).to eq "application/n-triples"
      end
    end

    context "ttl", :vcr do
      before do
        get :subject, {:subject => 'http://dbpedia.org/resource/Berlin', :format => :ttl}
      end
      it "should return a graph" do
        expect(RDF::Turtle::Reader.new(response.body).statements.to_a.length).not_to eq 0
      end
      it "should be n-triples" do
        expect(response.content_type).to eq "text/turtle"
      end
    end

    context "invalid", :vcr do
      it "should be of type 404 Routing Error" do
        expect{get :subject, {:subject => 'http://dbpedia.org/resource/Berlin', :format => :invalid}}.to raise_error(ActionController::RoutingError)
      end

      it "should output valid response formats" do
        expect{get :subject, {:subject => 'http://dbpedia.org/resource/Berlin', :format => :invalid}}.to raise_error(ActionController::RoutingError, /[ttl].+[application\/ld\+json]/)
      end
    end

  end
end
