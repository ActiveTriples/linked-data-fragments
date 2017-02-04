module LinkedDataFragments
  class Blazegraph < BackendBase
    def initialize
      #@repo ||= ::RDF::Blazegraph::Repository.new(uri: Setting.cache_backend_url, context: Setting.cache_backend_context)
      self.cache_backend_url = Setting.cache_backend_url
      self.cache_backend_context = Setting.cache_backend_context
      @repo ||= ::RDF::Blazegraph::Repository.new(Setting.cache_backend_url)
    end

    def retrieve(uri)
      @repo.load(uri) unless @repo.has_subject?(RDF::URI.new(uri))

      @repo.query(:subject => RDF::URI.new(uri))
    end

    def delete_all
      @repo.clear
    end
  end
end
