require 'rails_helper'

describe 'subject routes' do
  it 'navigates to the subject controller on a single subject param' do
    expect(get '/http://dbpedia.org/resource/Berlin')
      .to route_to controller: 'subject', 
                   action:     'subject', 
                   subject:    'http://dbpedia.org/resource/Berlin'
  end
  
  it 'navigates to the subject controller even if it is a root URI' do
    expect(get "/http://dbpedia.org")
      .to route_to controller: 'subject', 
                   action:     'subject', 
                   subject:    'http://dbpedia.org'
  end

  it 'navigates to the subject controller if a good format is provided' do
    expect(get '/http://dbpedia.org.ttl')
      .to route_to controller: 'subject', 
                   action:     'subject', 
                   subject:    'http://dbpedia.org', 
                   format:     'ttl'
  end
end
