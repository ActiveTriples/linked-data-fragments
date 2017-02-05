require 'rack/linkeddata'
require 'linked_data_fragments'

require 'rdf/turtle'
require 'json/ld'

module LinkedDataFragments
  ##
  # A basic cache server.
  #
  # @example Mounting in a Rails application.
  #   # In config/application.rb, or an initializer, etc... 
  #   require 'linked_data_fragments/cache_server'
  #
  #   # In config/routes.rb
  #   Rails.application.routes.draw do
  #     # ...
  #     # mounting at `"/ldcache"`
  #     mount LinkedDataFragments::CacheServer::APPLICATION => '/ldcache' 
  #   end
  #
  # @see http://www.rubydoc.info/gems/rack/Rack
  class CacheServer
    APPLICATION = Rack::Builder.new do
      use Rack::LinkedData::ContentNegotiation

      map '/' do 
        run LinkedDataFragments::CacheServer.new
      end
    end

    ##
    # 
    # @param env [Rack::Request::Env]
    # @return [Array]
    #
    # @see Rack::Response#finish
    def call(env)
      route(env)
    rescue RequestError => err
      [err.status, err.headers, err.body]
    end

    private

    ##
    # Routes the request environment and returns a response.
    #
    # @param env [Rack::Request::Env]
    # @return [Array] A Rack response array, with an {RDF::Enumerable} in the 
    #   body position.
    #
    # @raise [RequestError] when an error is encountered in routing or building
    #   the response.
    # @see Rack::Response#finish
    def route(env)
      query = Rack::Utils.parse_nested_query(env['QUERY_STRING'])

      if query.empty?
        raise NotFound unless env['PATH_INFO'] == '/'
        [200, {}, LinkedDataFragments::DatasetBuilder.new.build]
      else
        [200, {}, Service.instance.cache.retrieve(query['subject'])]
      end
    end

    def endpoint_route
      LinkedDataFragments::Settings.uri_endpoint_route
    end

    public

    ##
    # A basic request error
    class RequestError < RuntimeError
      BODY   = 'Unknown Server Error'.freeze
      STATUS = 500.freeze

      ##
      # @return [Integer] the http status code for the error
      def status
        self.class::STATUS
      end
      
      ##
      # @return [Hash<String, String>] http headers to add in error handling
      def headers
        {}
      end
      
      ##
      # @return [#read]
      def body
        StringIO.new(self.class::BODY)
      end
    end

    ##
    # 404 NotFound
    class NotFound < RequestError
      BODY   = 'Resource Not Found'.freeze
      STATUS = 404.freeze
    end
  end
end
