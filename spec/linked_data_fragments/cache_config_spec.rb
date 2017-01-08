require 'rails_helper'

RSpec.describe LinkedDataFragments::CacheConfig do
  describe '#cache_config' do
    context 'when no cache config defined' do
      let(:test_uri) { 'http://experimental.worldcat.org/fast/609348/rdf.xml' }
      before do
        allow(Rails.application.config.x).to receive(:method_missing).with(:cache_config).and_return({})
      end

      it 'should default values to nil and respond with enabled? false' do
        cache_config = LinkedDataFragments::CacheConfig.new(test_uri)
        expect(cache_config.enabled?).to be false
        expect(cache_config.connection_timeout).to be_nil
        expect(cache_config.so_timeout).to be_nil
        expect(cache_config.minexpiry).to be_nil
        expect(cache_config.expiry).to be_nil
        expect(cache_config.mimetype).to be_nil
        expect(cache_config.kind).to be_nil
      end
    end

    context 'when cache default configs are defined, but no endpoints' do
      let(:test_uri) { 'http://experimental.worldcat.org/fast/609348/rdf.xml' }
      let(:cache_disabled_config) do
        {
          enabled: false,
          connection_timeout: 10_000,
          so_timeout: 10_000,
          minexpiry: 86_400,
          expiry: 86_400
        }
      end
      let(:cache_enabled_config) do
        {
          enabled: true,
          connection_timeout: 10_000,
          so_timeout: 60_000,
          minexpiry: 86_400,
          expiry: 86_400
        }
      end

      it 'should return config values and respond with enabled? false when cache config is disabled' do
        allow(Rails.application.config.x).to receive(:method_missing).with(:cache_config).and_return(cache_disabled_config)
        cache_config = LinkedDataFragments::CacheConfig.new(test_uri)
        expect(cache_config.enabled?).to be false
        expect(cache_config.connection_timeout).to eq 10_000
        expect(cache_config.so_timeout).to eq 10_000
        expect(cache_config.minexpiry).to eq 86_400
        expect(cache_config.expiry).to eq 86_400
        expect(cache_config.mimetype).to be_nil
        expect(cache_config.kind).to be_nil
      end

      it 'should return default config values when cache is enabled' do
        allow(Rails.application.config.x).to receive(:method_missing).with(:cache_config).and_return(cache_enabled_config)
        cache_config = LinkedDataFragments::CacheConfig.new(test_uri)
        expect(cache_config.enabled?).to be true
        expect(cache_config.connection_timeout).to eq 10_000
        expect(cache_config.so_timeout).to eq 60_000
        expect(cache_config.minexpiry).to eq 86_400
        expect(cache_config.expiry).to eq 86_400
        expect(cache_config.mimetype).to be_nil
        expect(cache_config.kind).to be_nil
      end
    end

    context 'when cache default configs and endpoints are defined' do
      let(:non_endpoint_configured_uri) { 'http://aims.fao.org/skosmos/rest/v1/data?uri=http://aims.fao.org/aos/agrovoc/c_3954' }
      let(:single_endpoint_configured_uri) { 'http://experimental.worldcat.org/fast/609348/rdf.xml' }
      let(:multi_endpoint_configured_uri_with_sub) { 'http://id.loc.gov/authorities/names/n79065220' }
      let(:multi_endpoint_configured_uri_without_sub) { 'http://id.loc.gov/authorities/subjects/sh85118553' }
      let(:cache_enabled_config) do
        {
          enabled: true,
          connection_timeout: 10_000,
          so_timeout: 60_000,
          minexpiry: 86_400,
          expiry: 86_400,
          endpoints: {
            loc_names: {
              prefix:   'http://id.loc.gov/authorities/names/',
              mimetype: 'application/ld+json',
              kind:     'linked data',
              expiry:   100_000
            },
            loc: {
              prefix:   'http://id.loc.gov/authorities',
              mimetype: 'application/ld+json',
              kind:     'linked data',
              expiry:   400_000
            },
            oclc: {
              prefix:   'http://experimental.worldcat.org/fast/',
              mimetype: 'application/ld+json',
              kind:     'linked data',
              expiry:   500_000
            }
          }
        }
      end

      before do
        allow(Rails.application.config.x).to receive(:method_missing).with(:cache_config).and_return(cache_enabled_config)
      end

      it 'should return default config for non-endpoint configured uri' do
        cache_config = LinkedDataFragments::CacheConfig.new(non_endpoint_configured_uri)
        expect(cache_config.enabled?).to be true
        expect(cache_config.connection_timeout).to eq 10_000
        expect(cache_config.so_timeout).to eq 60_000
        expect(cache_config.minexpiry).to eq 86_400
        expect(cache_config.expiry).to eq 86_400
        expect(cache_config.mimetype).to be_nil
        expect(cache_config.kind).to be_nil
      end

      it 'should return endpoint overridden config for endpoint configure uri' do
        cache_config = LinkedDataFragments::CacheConfig.new(single_endpoint_configured_uri)
        expect(cache_config.enabled?).to be true
        expect(cache_config.connection_timeout).to eq 10_000
        expect(cache_config.so_timeout).to eq 60_000
        expect(cache_config.minexpiry).to eq 86_400
        expect(cache_config.expiry).to eq 500_000
        expect(cache_config.mimetype).to eq 'application/ld+json'
        expect(cache_config.kind).to eq 'linked data'
      end

      it 'should return most specific prefix match for multiple matching endpoints' do
        cache_config = LinkedDataFragments::CacheConfig.new(multi_endpoint_configured_uri_with_sub)
        expect(cache_config.enabled?).to be true
        expect(cache_config.connection_timeout).to eq 10_000
        expect(cache_config.so_timeout).to eq 60_000
        expect(cache_config.minexpiry).to eq 86_400
        expect(cache_config.expiry).to eq 100_000
        expect(cache_config.mimetype).to eq 'application/ld+json'
        expect(cache_config.kind).to eq 'linked data'
      end

      it 'should return general prefix match when multiple configured for a host but more specific do not match' do
        cache_config = LinkedDataFragments::CacheConfig.new(multi_endpoint_configured_uri_without_sub)
        expect(cache_config.enabled?).to be true
        expect(cache_config.connection_timeout).to eq 10_000
        expect(cache_config.so_timeout).to eq 60_000
        expect(cache_config.minexpiry).to eq 86_400
        expect(cache_config.expiry).to eq 400_000
        expect(cache_config.mimetype).to eq 'application/ld+json'
        expect(cache_config.kind).to eq 'linked data'
      end
    end
  end
end
