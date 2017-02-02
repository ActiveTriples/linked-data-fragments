require 'spec_helper'

describe LinkedDataFragments::Settings do
  describe '.app_root' do
    it 'gives a relative path string "." by default'
    it 'when called within a rails app gives Rails.root'
    it 'gives APP_ROOT when available'
  end

  describe '.config' do
    it 'loads the config file'
  end  

  describe '.config_path' do
    it 'gives the config file path' do
      expect(described_class.config_path)
        .to eq "#{described_class.app_root}/config/ldf.yml"
    end
  end
  
  describe '.env' do
    it 'defaults to "development"'
  end
end
