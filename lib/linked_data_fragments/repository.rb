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
    # @!attribute [r] repository
    #   @return [RDF::Repository]
    attr_reader :repository

    ##
    # @param repository [RDF::Repository] a repository instance
    def initialize(repository: RDF::Repository.new)
      @repository = repository
    end

    ##
    # @see BackendBase#add
    def add(uri, context: cache_backend_context)
      graph_for(context).load(uri)
    end

    ##
    # Removes all resources from the backend.
    #
    # @return [void]
    def delete_all!(context: cache_backend_context)
      graph_for(context).clear
    end

    ##
    # @see BackendBase#empty?
    def empty?(context: cache_backend_context)
      graph_for(context).empty?
    end

    ##
    # @see BackendBase#has_resource?
    def has_resource?(uri, context: cache_backend_context)
      graph_for(context).has_subject?(RDF::URI.intern(uri))
    end

    ##
    # @see BackendBase#retrieve
    def retrieve(uri, context: cache_backend_context)
      add(uri, context: context) unless has_resource?(uri, context: context)

      repository.query(subject: RDF::URI.intern(uri))
    end

    private
    
    def graph_for(context)
      if RDF::VERSION.to_a[0] == '1'
        RDF::Graph.new(context, data: repository)
      else
        RDF::Graph.new(graph_name: context, data: repository)
      end
    end
  end
end
