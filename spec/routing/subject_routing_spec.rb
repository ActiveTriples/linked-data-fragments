require 'rails_helper'

RSpec.describe "subject routes" do
  it "should navigate to the subject controller on a single subject param" do
    expect(get "/http://dbpedia.org/resource/Berlin").to route_to :controller => "subject", :action => "subject", :subject=>"http://dbpedia.org/resource/Berlin"
  end
end
