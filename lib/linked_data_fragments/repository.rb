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
    def add(uri)
      repository.load(uri)
    end

    ##
    # Removes all resources from the backend.
    #
    # @return [void]
    def delete_all!
      repository.clear
    end

    ##
    # @see BackendBase#empty?
    def empty?
      repository.empty?
    end

    ##
    # @see BackendBase#has_resource?
    def has_resource?(uri)
      repository.has_subject?(RDF::URI.intern(uri))
    end

    ##
    # @see BackendBase#retrieve
    def retrieve(uri)
      repository.load(uri) unless has_resource?(uri)

      repository.query(subject: RDF::URI.intern(uri))
    end
  end
end
