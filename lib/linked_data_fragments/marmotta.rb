module LinkedDataFragments
  class Marmotta < BackendBase

    def initialize
      self.cache_backend_url = Setting.cache_backend_url
      self.cache_backend_context = Setting.cache_backend_context
      @connection = ::Marmotta::Connection.new(uri: Setting.cache_backend_url, context: Setting.cache_backend_context)
    end

    def retrieve(uri)
      resource = ::Marmotta::Resource.new(uri, connection: @connection)
      resulting_graph = resource.get

      return resulting_graph
    end

    def delete_all
      @connection.delete_all
    end
  end
end
