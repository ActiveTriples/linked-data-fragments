module LinkedDataFragments
  ##
  # A base class for RDF backends.
  #
  # Several abstract methods are defined, which implementations must provide 
  # concrete versions of.
  #
  # @note this interface provides no method for clearing (deleting) individual
  #   resources from the cache.
  class BackendBase
    ##
    # A backend factory.
    #
    # @param name [#to_sym]
    # @return [BackendBase] a backend instance
    #
    # @raise [ArgumentError] when the name does not match a repository
    def self.for(name: :repository)
      case name.to_sym
      when :marmotta
        LinkedDataFragments::Marmotta.new
      when :repository
        LinkedDataFragments::Repository.new
      when :blazegraph
        LinkedDataFragments::Blazegraph.new
      else
        raise ArgumentError, "Invalid backend `#{name}` specified."
      end
    end

    ##
    # @!attribute [rw] cache_backend_url
    #   @return [String, nil] a target url in string form; `nil` may be 
    #     returned when the backend repository is not remote.
    # @!attribute [rw] cache_backend_context
    #   @return [String, nil] the context URI for the cache. When the backend 
    #     supports quads, statements will be stored in this context. `nil` 
    #     selects the default context.
    #   @see https://www.w3.org/TR/rdf11-concepts/#section-dataset for 
    #     information about named graphs ("contexts") in the RDF abstract syntax
    #   @see RDF::Dataset for documentation covering named graph support in 
    #     RDF.rb
    #   @see RDF::Dataset#supports? for details about `:graph_name` support in 
    #     Repositories
    attr_accessor :cache_backend_url, :cache_backend_context
    
    ##
    # @abstract Add a resource to the backend. This method retrieves the 
    #   resource from its URI.
    # 
    # @return [void]
    # @raise [IOError, Net::HTTPError] when retrieving the resource fails with
    #   a non-2xx HTTP status code.
    # @see RDF::Graph#load  this is typical implementation
    def add(uri)
      raise NotImplementedError, 
            "#{self.class} should implement `#empty?`, but does not."
    end

    ##
    # @deprecated Use {#delete_all!} instead.
    # @return [void]
    def delete_all
      warn "[DEPRECATION] `#{self.class}#delete_all` is deprecated; " \
           "use `#{self.class}#delete_all! instead. Called from: " \
           "#{Gem.location_of_caller.join(':')}"
      delete_all!
    end

    ##
    # @abstract Implementations must remove all resources from the backend.
    # 
    # @return [void]
    def delete_all!
      raise NotImplementedError, 
            "#{self.class} should implement `#delete_all!`, but does not."
    end

    ##
    # @abstract
    # @return [Boolean] `true` if no resources are stored.
    def empty?
      raise NotImplementedError, 
            "#{self.class} should implement `#empty?`, but does not."
    end

    ##
    # @deprecation This now just echos the argument. Callers should remove 
    #   sends to this method, and use the argument instead.
    # @param uri [String, RDF::URI] a URI or URI-like string
    # @return [String, RDF::URI] the mapped string
    def get_resource_uri(uri)
      warn '[DEPRECATION] #get_resource_uri echos its argument. Callers ' \
           'should replace method calls with the argument, instead ' \
           "Called from: #{Gem.location_of_caller.join(':')}"
      uri
    end

    ##
    # @abstract checks whether the resource is in the cache
    #
    # @param uri [String, RDF::URI] a URI or URI-like string
    # @return [Boolean]
    def has_resource?(uri)
      raise NotImplementedError,
            "#{self.class} should implement `#has_resource?`, but does not."
    end

    ##
    # @abstract Retrieves RDF statements for a selected resource.
    #
    # @todo Should this simply implement the base verison against
    #   `RDF::Repository`?
    # @todo What are we supposed to return if the resource does not exist?
    #
    # @param uri [String, RDF::URI] a URI or URI-like string
    # @return [RDF::Enumerable] the statements representing requested resource
    def retrieve(uri)
      raise NotImplementedError,
            "#{self.class} should implement `#retrieve!`, but does not."
    end
  end
end
