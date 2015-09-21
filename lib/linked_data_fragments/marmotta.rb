module LinkedDataFragments
  class Marmotta

    def initialize
      @connection = ::Marmotta::Connection.new(uri: Setting.cache_backend_url, context: Setting.cache_backend_context)
    end

    def retrieve(uri)
      resource = ::Marmotta::Resource.new(uri, connection: @connection)
      resulting_graph = resource.get
      resource.post(resulting_graph)

      return resulting_graph
    end

    def delete_all
      @connection.delete_all
    end
  end
end
