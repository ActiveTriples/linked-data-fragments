require 'linked_data_fragments'
require 'rdf/turtle'

module LinkedDataFragments
  ##
  # A basic Cache Server application
  class CacheServer
    ##
    # @param app [#call]
    def initialize(app)
      @app = app
    end

    ##
    # @param env [Rack::Request::Env]
    def call(env)
      route(env)
    end

    private

    ##
    # @param env [Rack::Request::Env]
    # @return[Rack::Request::Env]
    def route(env)
      case env['PATH_INFO']
      when '/'
        [200, {}, LinkedDataFragments::DatasetBuilder.new.build]
      when /#{endpoint_route}/
        params = Rack::Utils.parse_nested_query(env['QUERY_STRING'])
        [200, {}, Service.instance.cache.retrieve(params['subject'])]
      else
        [404, {}, '']
      end
    end

    def endpoint_route
      LinkedDataFragments::Settings.uri_endpoint_route
    end
  end
end
