require 'rails_helper'

RSpec.describe DatasetController do
  describe "index" do
    context "JSON-LD" do
      before do
        get :index, :format => :jsonld
      end
      it "should return a graph" do
        expect(JSON::LD::Reader.new(response.body).statements.to_a.length).not_to eq 0
      end
      it "should be JSON-LD" do
        expect(response.content_type).to eq "application/ld+json"
      end
    end
  end
end
