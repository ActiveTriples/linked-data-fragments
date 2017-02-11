require 'rails_helper'

describe 'dataset routes' do
  describe '/dataset' do
    it 'navigates to the root dataset' do
      expect(get "/dataset").to route_to controller: 'dataset', 
                                         action:     'index'
    end
  end

  describe '/dataset/:dataset' do
    it 'navigates to the dataset controller' do
      expect(get "/dataset/lcsh")
        .to route_to controller: 'dataset', 
                     action:     'show',
                     id:         'lcsh'
      
    end
  end
end
