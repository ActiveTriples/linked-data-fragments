##
# A class to hold site-wide configuration.
# @todo extract to a configuration file.
class Setting
  class << self
    def config
      # handle the case of the config file not existing (before running the generator)
      return {} unless File.exists?(config_path)
      @config ||= YAML::load(File.open(config_path)).fetch(env)
        .with_indifferent_access
    end

    def app_root
      return @app_root if @app_root
      @app_root = Rails.root if defined?(Rails) and defined?(Rails.root)
      @app_root ||= APP_ROOT if defined?(APP_ROOT)
      @app_root ||= '.'
    end

    def env
      return @env if @env
      #The following commented line always returns "test" in a rails c production console. Unsure of how to fix this yet...
      #@env = ENV["RAILS_ENV"] = "test" if ENV
      @env ||= Rails.env if defined?(Rails) and defined?(Rails.root)
      @env ||= 'development'
    end

    def config_path
      File.join(app_root, 'config', 'ldf.yml')
    end

    def uri_endpoint
      Setting.config[:uri_endpoint] || 'http://localhost:3000/{?subject}'
    end

    def uri_endpoint_route
      if uri_endpoint.match(/^http[s]*\:\/\/.+\//)
        endpoint = uri_endpoint.gsub(/^http[s]*\:\/\/[^\/]+/, '')
        endpoint.gsub!('{?subject}', '*subject')
      else
        #FIXME: What type of error should this be? Need to unit test this as well once figured out.
        raise ArgumentError, 'Invalid uri endpoint url specified'
      end

      return endpoint
    end

    def uri_root
      Setting.config[:uri_root] || 'http://localhost:3000/#dataset'
    end

    def cache_backend
      Setting.config[:cache_backend][:provider] || 'marmotta'
    end

    def cache_backend_url
      Setting.config[:cache_backend][:url] || 'http://localhost:8988/marmotta'
    end

    def cache_backend_context
      Setting.config[:cache_backend][:context] || 'linked_data_fragments_unknown'
    end
  end
end
