module LinkedDataFragments
  class CacheConfig

    attr_reader :enabled # enable/disable automatic caching of remote resources from linked data sources
    attr_reader :connection_timeout # how long to wait in ms when attempting to connect to a linked data source (default: 10000 ms)
    attr_reader :so_timeout # how long to wait in msz for data to come back from a server (default: 60000 ms)
    attr_reader :minexpiry # minimum expiry time before which a resource is refreshed from original linked data source (use to avoid too short expiry times returned by servers) (default: 1 day)
    attr_reader :expiry # default expiry time in seconds if not otherwise given (default: 1 day)
    attr_reader :cache_endpoint_registry # override configurations for specific endpoints

    def self.default_enabled
      @default_enabled = false.freeze
    end
    private_class_method :default_enabled

    def self.default_connection_timeout
      @default_connection_timeout = 10000
    end
    private_class_method :default_connection_timeout

    def self.default_so_timeout
      @default_so_timeout = 60000
    end
    private_class_method :default_so_timeout

    def self.default_minexpiry
      @default_minexpiry = 86400
    end
    private_class_method :default_minexpiry

    def self.default_expiry
      @default_expiry = 86400
    end
    private_class_method :default_expiry

    def self.empty_cache_endpoint_registry
      # by setting to nil, it will use the default minter in the minter gem
      @empty_cache_endpoint_registry = {}
    end
    private_class_method :empty_cache_endpoint_registry

    def initialize
      @enabled = self.class.send(:default_enabled)
      @connection_timeout = self.class.send(:default_connection_timeout)
      @so_timeout = self.class.send(:default_so_timeout)
      @minexpiry = self.class.send(:default_minexpiry)
      @expiry = self.class.send(:default_expiry)
      @cache_endpoint_registry = self.class.send(:empty_cache_endpoint_registry)
    end

    def enabled=(new_enabled)
      @enabled = new_enabled
    end

    def reset_enabled
      @enabled = self.class.send(:default_enabled)
    end

    def connection_timeout=(new_connection_timeout)
      @connection_timeout = new_connection_timeout
    end

    def reset_connection_timeout
      @connection_timeout = self.class.send(:default_connection_timeout)
    end

    def so_timeout=(new_so_timeout)
      @so_timeout = new_so_timeout
    end

    def reset_so_timeout
      @so_timeout = self.class.send(:default_so_timeout)
    end

    def minexpiry=(new_minexpiry)
      @minexpiry = new_minexpiry
    end

    def reset_minexpiry
      @minexpiry = self.class.send(:default_minexpiry)
    end

    def expiry=(new_expiry)
      @expiry = new_expiry
    end

    def reset_expiry
      @expiry = self.class.send(:default_expiry)
    end

    def register_cache_endpoint(prefix, name, mimetype, expiry=@default_expiry, kind="linked data", enpoint=nil)
      ep_config = { name: name, kind: kind, prefix: prefix, enpoint: enpoint, mimetype: mimetype, expiry_time: expiry }
      @cache_endpoint_registry[name] = ep_config
    end

    def unregister_cache_endpoint(name)
      @cache_endpoint_registry.delete(host)
    end

    def find_cache_endpoint_by(field, value)
      case field
        when :name
          return @cache_endpoint_registry[value]
        when :prefix
          return @cache_endpoint_registry.select { |k,v| v[:prefix] == value }
        else
          # TODO add warning about what is not supported
          return {}
      end
    end
  end
end
