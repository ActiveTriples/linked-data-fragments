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
        run CacheServer.new
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

    ##
    # @param dataset [Dataset]
    # @param query   [Hash<String, String>]
    #
    # @return [Array] A Rack response array, with an {RDF::Enumerable} in the 
    #   body position
    def response_for(dataset, query)
      resource = if query['subject']
        Service.instance
          .cache.retrieve(query['subject'], context: dataset.to_term)
      else
        dataset 
      end

      [200, {}, resource]
    end

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

      case env['PATH_INFO']
      when /\/$/
        response_for(DatasetBuilder.new.build, query)
      when /\/dataset\/(?<name>.*)$/
        response_for(DatasetBuilder.for(name: Regexp.last_match[:name]), query)
      else
        raise NotFound
      end
    end

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
