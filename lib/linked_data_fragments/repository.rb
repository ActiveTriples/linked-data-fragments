module LinkedDataFragments
  ##
  # A basic `RDF::Repository` backend. This simply wraps RDF::Repository with
  # the smaller `BackendBase` interface.
  #

  # @example with a new in-memory repository
  #   backend = LinkedDataFragments.new
  #   backend.retrieve('http://example.com/moomin')
  #
  # @example with an existing repository instance
  #   my_repository = RDF::Repository.new
  #   backend = LinkedDataFragments.new(repository: my_repository)
  #   backend.retrieve('http://example.com/moomin')
  #
  class Repository < BackendBase
    ##
    # @param repository [RDF::Repository] a repository instance
    def initialize(repository: RDF::Repository.new)
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

    ##
    # @see BackendBase#retrieve
    def retrieve(uri)
      if !has_resource?(uri)
        uri_to_load = get_resource_uri(uri)
        @repo.load(uri_to_load)
      end

      resulting_graph = @repo.query(:subject => RDF::URI.new(uri))
      return resulting_graph
    end
  end
end
