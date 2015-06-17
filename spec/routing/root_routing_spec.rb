require 'rails_helper'

RSpec.describe "root routes" do
  it "should navigate to the dataset controller" do
    expect(get "/").to route_to :controller => "dataset", :action => "index"
  end
end
