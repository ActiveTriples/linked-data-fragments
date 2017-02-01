require 'spec_helper'

require 'rack/test'
require 'linked_data_fragments/cache_server'

describe LinkedDataFragments::CacheServer do
  include Rack::Test::Methods

  let(:app) { described_class.new(proc { |env| }) }

  it 'says hello' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello World')
  end
end
