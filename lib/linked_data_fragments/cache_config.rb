module LinkedDataFragments
  class CacheConfig
    # NOTE:  Define default and endpoint cache configuration values in /config/cache.yml

    # @return [Integer] how long to wait in ms when attempting to connect to a linked data source (default: 10000 ms)
    attr_reader :connection_timeout

    # @return [Integer] how long to wait in msz for data to come back from a server (default: 60000 ms)
    attr_reader :so_timeout

    # @return [Integer] minimum expiry time before which a resource is refreshed from original linked data source (use to avoid too short expiry times returned by servers) (default: 84600 s)
    attr_reader :minexpiry

    # @return [Integer] default expiry time in seconds if not otherwise given (default: 84600 s)
    attr_reader :expiry

    # @return [String] endpoints can specify the mimetype the authority is expected to return  (default: nil)
    attr_reader :mimetype

    # @return [String] endpoints can specify the kind of authority with values:  linked data | ld cache | regexuri | sparql | NONE (Blacklist)  (default: nil)
    attr_reader :kind

    # Get cache configuration specific to a URI
    # @param uri [String] URI for the resource to be retrieved
    # @return [CacheConfig] the cache configuration or nil if cache has not been configured
    def initialize(uri)
      config_defaults = full_cache_config
      if config_defaults.nil? || config_defaults.length <= 0
        @enabled = false
      else
        merge_cache_config(config_defaults, endpoint_cache_config(config_defaults, uri))
      end
    end

    # Determine if automatic caching of remote resources from linked data sources is enabled/disabled (default: false)
    # @return [CacheConfig] the cache configuration or nil if cache has not been configured
    def enabled?
      @enabled
    end

    private

      # Get cache configuration.
      # @return [Hash] a hash of full configuration of caching including defaults and endpoint specific configurations
      def full_cache_config
        Rails.application.config.x.cache_config
      end

      # Merge endpoint specific cache config with default cache config
      # @param default [Hash] full configuration of caching including defaults
      # @param endpoint [Hash] endpoint specific cache config
      # @return [Hash] a single cache config with defaults and endpoint specific cache configs merged.  Endpoint configs override defaults.
      def merge_cache_config(default, endpoint)
        @enabled = (endpoint.key? :enabled) ? endpoint[:enabled] : default[:enabled]
        @connection_timeout = (endpoint.key? :connection_timeout) ? endpoint[:connection_timeout] : default[:connection_timeout]
        @so_timeout = (endpoint.key? :so_timeout) ? endpoint[:so_timeout] : default[:so_timeout]
        @minexpiry = (endpoint.key? :minexpiry) ? endpoint[:minexpiry] : default[:minexpiry]
        @expiry = (endpoint.key? :expiry) ? endpoint[:expiry] : default[:expiry]
        @mimetype = endpoint[:mimetype] if endpoint.key? :mimetype
        @kind = endpoint[:kind] if endpoint.key? :kind
      end

      # Find cache config specific to an endpoint
      # @param full_cache_config [Hash] full configuration of caching including defaults and endpoint specific configurations
      # @param uri URI for the resource to be retrieved
      # @return [Hash] a hash of endpoint cache configuration with the prefix that is the best match to the URI
      def endpoint_cache_config(full_cache_config, uri)
        potential_matches = potential_endpoint_cache_configs full_cache_config, uri
        best_match_endpoint_cache_config potential_matches
      end

      # Find all potential endpoint matches of cache configurations
      # @param full_cache_config [Hash] full configuration of caching including defaults and endpoint specific configurations
      # @param uri [String] URI for the resource to be retrieved
      # @return [Hash] a hash of all endpoint cache configurations that are potential matches for the uri
      def potential_endpoint_cache_configs(full_cache_config, uri)
        endpoints_cache_config = full_cache_config[:endpoints]
        return {} if endpoints_cache_config.nil? || endpoints_cache_config.length <= 0
        endpoints_cache_config.select { |_k, v| uri.start_with? v[:prefix] }
      end

      # Find best matching endpoint cache config of all potential matches
      # @param potential_matches [Hash] a hash of all endpoint cache configurations that are potential matches for the uri
      # @return [Hash] a hash endpoint cache configuration with the prefix that is the best match to the URI
      def best_match_endpoint_cache_config(potential_matches)
        return {} if potential_matches.nil? || potential_matches.length <= 0
        match = potential_matches.first.second # gets value of first item which is the hash of configs for an endpoint
        return match if potential_matches.length == 1
        potential_matches.each { |_k, v| match = v if v[:prefix].length > match[:prefix].length }
        match
      end

  #   public
  #   # Used by LinkedDataFragments class to set caching configuration for...
  #   # * enabled
  #   # * connection_timeout
  #   # * so_timeout
  #   # * minexpiry
  #   # * expiry
  #   #
  #   # And to register caching endpoints
  #   #
  #   # @example Configure all configurable properties
  #   #   LinkedDataFragments::Application.configure_cache do |cache_config|
  #   #     cache_config.base_uri         = "http://www.example.org/annotations/"
  #   #     cache_config.localname_minter = lambda { |prefix=""| prefix+SecureRandom.uuid }
  #   #     cache_config.unique_tags      = true
  #   #   end
  #   #
  #   # @example Usage of base uri and local name
  #   #   # uri = base_uri + localname"
  #   #   annotation = LD4L::OpenAnnotationRDF::CommentAnnotation.new(
  #   #     ActiveTriples::LocalName::Minter.generate_local_name(
  #   #         LD4L::OpenAnnotationRDF::CommentBody, 10, 'a',
  #   #         LD4L::OpenAnnotationRDF.configuration.localname_minter ))
  #   #   annotation.rdf_subject
  #   #   # => "http://www.example.org/annotations/a9f85752c-9c2c-4a65-997a-68482895a656"
  #   #
  #   # @note Use LD4L::OpenAnnotationRDF.configure to call the methods in this class.  See 'Configure all configurable
  #   #   properties' example for most common approach to configuration.
  #
  #   attr_reader :enabled # enable/disable automatic caching of remote resources from linked data sources
  #   attr_reader :connection_timeout # how long to wait in ms when attempting to connect to a linked data source (default: 10000 ms)
  #   attr_reader :so_timeout # how long to wait in msz for data to come back from a server (default: 60000 ms)
  #   attr_reader :minexpiry # minimum expiry time before which a resource is refreshed from original linked data source (use to avoid too short expiry times returned by servers) (default: 1 day)
  #   attr_reader :expiry # default expiry time in seconds if not otherwise given (default: 1 day)
  #   attr_reader :cache_endpoint_registry # override configurations for specific endpoints
  #
  #   def self.default_enabled
  #     @default_enabled = false.freeze
  #   end
  #   private_class_method :default_enabled
  #
  #   def self.default_connection_timeout
  #     @default_connection_timeout = 10000
  #   end
  #   private_class_method :default_connection_timeout
  #
  #   def self.default_so_timeout
  #     @default_so_timeout = 60000
  #   end
  #   private_class_method :default_so_timeout
  #
  #   def self.default_minexpiry
  #     @default_minexpiry = 86400
  #   end
  #   private_class_method :default_minexpiry
  #
  #   def self.default_expiry
  #     @default_expiry = 86400
  #   end
  #   private_class_method :default_expiry
  #
  #   def self.empty_cache_endpoint_registry
  #     # by setting to nil, it will use the default minter in the minter gem
  #     @empty_cache_endpoint_registry = {}
  #   end
  #   private_class_method :empty_cache_endpoint_registry
  #
  #   def initialize
  #     @enabled = self.class.send(:default_enabled)
  #     @connection_timeout = self.class.send(:default_connection_timeout)
  #     @so_timeout = self.class.send(:default_so_timeout)
  #     @minexpiry = self.class.send(:default_minexpiry)
  #     @expiry = self.class.send(:default_expiry)
  #     @cache_endpoint_registry = self.class.send(:empty_cache_endpoint_registry)
  #   end
  #
  #   def enabled=(new_enabled)
  #     @enabled = new_enabled
  #   end
  #
  #   def reset_enabled
  #     @enabled = self.class.send(:default_enabled)
  #   end
  #
  #   def connection_timeout=(new_connection_timeout)
  #     @connection_timeout = new_connection_timeout
  #   end
  #
  #   def reset_connection_timeout
  #     @connection_timeout = self.class.send(:default_connection_timeout)
  #   end
  #
  #   def so_timeout=(new_so_timeout)
  #     @so_timeout = new_so_timeout
  #   end
  #
  #   def reset_so_timeout
  #     @so_timeout = self.class.send(:default_so_timeout)
  #   end
  #
  #   def minexpiry=(new_minexpiry)
  #     @minexpiry = new_minexpiry
  #   end
  #
  #   def reset_minexpiry
  #     @minexpiry = self.class.send(:default_minexpiry)
  #   end
  #
  #   def expiry=(new_expiry)
  #     @expiry = new_expiry
  #   end
  #
  #   def reset_expiry
  #     @expiry = self.class.send(:default_expiry)
  #   end
  #
  #   def register_cache_endpoint(prefix, name, mimetype, expiry=@default_expiry, kind="linked data", enpoint=nil)
  #     ep_config = { name: name, kind: kind, prefix: prefix, enpoint: enpoint, mimetype: mimetype, expiry_time: expiry }
  #     @cache_endpoint_registry[name] = ep_config
  #   end
  #
  #   def unregister_cache_endpoint(name)
  #     @cache_endpoint_registry.delete(host)
  #   end
  #
  #   def find_cache_endpoint_by(field, value)
  #     case field
  #       when :name
  #         return @cache_endpoint_registry[value]
  #       when :prefix
  #         return @cache_endpoint_registry.select { |k,v| v[:prefix] == value }
  #       else
  #         # TODO add warning about what is not supported
  #         return {}
  #     end
  #   end
  end
end
