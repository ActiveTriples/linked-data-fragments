require 'rails_helper'

RSpec.describe SubjectController do

  describe "settings" do
    context '#cache_service' do
      it 'defaults be set to a valid service with a retrieve method' do
        expect(SubjectController.cache_service.respond_to?(:retrieve)).to eq true
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
        get :subject, {:subject => 'http://dbpedia.org/resource/Berlin', :format => :nt} #This breaks in Blazegraph? CHECKME
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
