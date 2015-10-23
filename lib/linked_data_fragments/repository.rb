module LinkedDataFragments
  class Repository

    def initialize
      @repo = RDF::Repository.new
    end

    def retrieve(uri)
      if !@repo.has_subject?(RDF::URI.new(uri))
        uri_to_load = get_resource_uri(uri)
        @repo.load(uri_to_load)
      end

      resulting_graph = @repo.query(:subject => RDF::URI.new(uri))
      return resulting_graph
    end

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
