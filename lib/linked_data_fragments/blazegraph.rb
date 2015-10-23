module LinkedDataFragments
  class Blazegraph

    def initialize
      #@repo ||= ::RDF::Blazegraph::Repository.new(uri: Setting.cache_backend_url, context: Setting.cache_backend_context)
      @repo ||= ::RDF::Blazegraph::Repository.new(Setting.cache_backend_url)
    end

    def retrieve(uri)
      if !@repo.has_subject?(RDF::URI.new(uri))
        uri_to_load = get_resource_uri(uri)
        @repo.load(uri_to_load)
      end

      resulting_graph = @repo.query(:subject => RDF::URI.new(uri))
      return resulting_graph
    end

    #http://localhost:3000/http://dbpedia.org/resource/Berlin?format=jsonld
    #http://localhost:3000/http://dbpedia.org/data/Berlin?format=jsonld

    def get_resource_uri(uri)
      if uri.match(/dbpedia.org\/resource\//)
        uri = 'http://dbpedia.org/data/' + uri.gsub(/.+dbpedia.org\/resource\//, '') + '.nt'
      end

      return uri
    end

    def delete_all
      @repo.clear
    end
  end
end
