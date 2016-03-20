require 'rails_helper'

RSpec.describe "root routes" do
  routes { LinkedDataFragments::Engine.routes }

  it "navigates to the dataset controller" do
    expect(get "/").to route_to :controller => "linked_data_fragments/dataset", :action => "index"
  end
end
