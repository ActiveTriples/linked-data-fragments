module LinkedDataFragments
  ##
  # The cache
  class Service
    include Singleton

    ##
    # @return [BackendBase]
    # @raise [BackendBase::UnsupportedBackend] when the configured repository is
    #   not supported
    def cache
      @cache ||= BackendBase.for(name: Settings.cache_backend)
    rescue BackendBase::UnsupportedBackend
      raise BackendBase::UnsupportedBackend, 'Invalid cache_backend set in the yml config'
    end
  end
end
