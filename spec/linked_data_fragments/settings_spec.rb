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

  # @todo: routing implements the wrong paths for `{?subject}` patterns FIXME!
  describe '.uri_endpoint_route' do
    let(:config_yaml) do
      <<YAML
#{described_class.env}:
  uri_endpoint: '#{endpoint}'
  uri_root: 'http://localhost:3000/'
  cache_backend:
    provider: 'repository'
YAML
    end

    let(:endpoint) { 'http://localhost:3000/{?subject}' }

    before do
      described_class.instance_variable_set :@config, nil

      allow(File)
        .to receive(:open)
        .with(described_class.config_path)
        .and_return(config_yaml)
    end

    it 'writes a route' do
      expect(described_class.uri_endpoint_route).to eq '/*subject'
    end


    context 'with an incorrect route' do
      let(:endpoint) { 'http://localhost:3000{?subject}' }

      it 'raises ArugmentError' do
        expect { described_class.uri_endpoint_route }.to raise_error ArgumentError
      end
    end

    context 'with deep endpoint path' do
      let(:endpoint) { 'https://www.example.com:8888/fds/a/{?subject}' }

      it 'writes a deep route' do
        expect(described_class.uri_endpoint_route).to eq '/fds/a/*subject'
      end
    end
  end
end
