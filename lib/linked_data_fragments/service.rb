module LinkedDataFragments
  ##
  # The cache
  class Service
    include Singleton

    ##
    # @return [BackendBase]
    def cache
      @cache ||= 
        LinkedDataFragments::BackendBase.for(name: Settings.cache_backend)
    end
  end
end
