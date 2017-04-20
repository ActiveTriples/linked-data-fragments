module LinkedDataFragments
  ##
  # The Blazegraph Backend. This simply wraps RDF::Blazegraph::Repository with
  # the smaller `BackendBase` interface.
  #

  # @example with a new blazegraph repository
  #   backend = LinkedDataFragments.new
  #   backend.retrieve('http://example.com/moomin')
  #
  # @example with an existing repository instance
  #   my_repository = RDF::Repository.new
  #   backend = LinkedDataFragments.new(repository: my_repository)
  #   backend.retrieve('http://example.com/moomin')
  #

  class Blazegraph < BackendBase

    #FIXME: How should cache backend context be used?
    def initialize(repository: ::RDF::Blazegraph::Repository.new(Setting.cache_backend_url))
      self.cache_backend_url = Setting.cache_backend_url
      self.cache_backend_context = Setting.cache_backend_context
      @repo = repository
    end

    ##
    # @see BackendBase#add
    def add(uri)
      uri_to_load = get_resource_uri(uri)
      @repo.load(uri_to_load)
    end

    ##
    # Removes all resources from the backend.
    #
    # @return [void]
    def delete_all!
      @repo.clear
    end

    ##
    # @see BackendBase#empty?
    def empty?
      @repo.empty?
    end

    ##
    # @see BackendBase#has_resource?
    def has_resource?(uri)
      @repo.has_subject?(RDF::URI.new(uri))
    end

    def retrieve(uri)
      if !@repo.has_subject?(RDF::URI.new(uri))
        uri_to_load = get_resource_uri(uri)
        @repo.load(uri_to_load)
      end

      resulting_graph = @repo.query(:subject => RDF::URI.new(uri))
      return resulting_graph
    end

    def query(q)
      #subject, predicate, object = q.split('||')
      q_split = q.split(' ')
      subject = q_split[0]
      predicate = q_split[1]
      object = q_split[2..-1].join(' ')

      if object.match(/\"@.+$/) || object.match(/\"@.+$/)
        lang_code = object.split('@').last
        object = object.split('@')[0..-2].join('@')
      end

      filter_part = ''
      initial_term_part = ''
      if object.match(/\*/)
        object.gsub!('*', '')
        initial_term_part = %{ ?term_ident #{predicate} ?plabel }
        if object.match(/^\(\?i\)/)
          filter_part = %{ FILTER regex( str(?plabel), #{object}, "i" ) }
        else
          filter_part = %{ FILTER regex( str(?plabel), #{object} ) }
        end

        if lang_code.present?
          filter_part += %{
          FILTER langMatches( lang(?plabel), "#{lang_code}" ) }
        end
      else
        initial_term_part = "?term_ident #{predicate} #{object}"
        if lang_code.present?
        initial_term_part += "@#{lang_code}"
        end
      end


      if subject.match(/^\?/)
            conditions = %{prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
        SELECT  DISTINCT ?term_ident ?plabel
WHERE   {  { #{initial_term_part}
            #{filter_part} }
        }
}

            puts conditions
      else
        conditions = %{prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
        SELECT  DISTINCT ?term_ident ?plabel
WHERE   {  { #{initial_term_part.gsub('?term_ident', subject)}
        #{filter_part} }
        }
}


      end

      term_result = sparql_interface.query(conditions)

      graph = ::RDF::Graph.new
      term_result.each do |term|
        term[:term_ident] = ::RDF::URI.new(subject) if term[:term_ident].blank?
        term[:term_predicate] = ::RDF::URI.new("http://www.w3.org/2000/01/rdf-schema##{predicate.split(':').last}") if predicate.include?('rdfs:')
        term[:term_predicate] = ::RDF::URI.new(predicate.gsub('<', '').gsub('>', '')) unless predicate.include?('rdfs:')
        if term[:plabel].present?
          graph << [term[:term_ident], term[:term_predicate], term[:plabel]]
        else
          graph << [term[:term_ident], term[:term_predicate], ::RDF::Literal.new(object.gsub('"', ''), language: lang_code.to_sym)]
        end

      end

      graph

    end

    def sparql_interface
      @sparql ||= SPARQL::Client.new(Setting.cache_backend_url)
      @sparql
    end
  end
end
