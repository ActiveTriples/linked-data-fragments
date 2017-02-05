module LinkedDataFragments
  ##
  # A class to hold site-wide configuration.
  #
  # @todo Extract to a configuration file.
  class Settings
    class << self
      ##
      # @return [String]
      def app_root
        return @app_root if @app_root
        @app_root = Rails.root if defined?(Rails) and defined?(Rails.root)
        @app_root ||= APP_ROOT if defined?(APP_ROOT)
        @app_root ||= '.'
      end

      ##
      # @return [Hash<String, String>] the settings from the YAML config
      #   at {.config_path}.
      def config
        @config ||= YAML::load(File.open(config_path))[env]
          .with_indifferent_access
      end

      ##
      # @return [String]
      def config_path
        File.join(app_root, 'config', 'ldf.yml')
      end

      ##
      # @return [String]
      def env
        return @env if @env
        #The following commented line always returns "test" in a rails c production console. Unsure of how to fix this yet...
        #@env = ENV["RAILS_ENV"] = "test" if ENV
        @env ||= Rails.env if defined?(Rails) and defined?(Rails.root)
        @env ||= 'development'
      end

      ##
      # @return [String]
      def uri_endpoint
        config[:uri_endpoint] || 'http://localhost:3000/{?subject}'
      end

      ##
      # @todo: document the purpose of thsi logic.
      def uri_endpoint_route
        if uri_endpoint.match(/^http[s]*\:\/\/.+\//)
          endpoint = uri_endpoint.gsub(/^http[s]*\:\/\/[^\/]+/, '')
          endpoint.gsub!('{?subject}', '*subject')
        else
          #FIXME: What type of error should this be? Need to unit test this as well once figured out.
          raise ArgumentError, 'Invalid uri endpoint url specified'
        end

        endpoint
      end

      def uri_root
        config[:uri_root] || 'http://localhost:3000/#dataset'
      end

      def cache_backend
        config[:cache_backend][:provider] || 'marmotta'
      end

      def cache_backend_url
        config[:cache_backend][:url] || 'http://localhost:8988/marmotta'
      end

      def cache_backend_context
        config[:cache_backend][:context] || 'linked_data_fragments_unknown'
      end
    end
  end
end
