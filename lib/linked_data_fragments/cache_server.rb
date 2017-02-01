
module LinkedDataFragments
  ##
  # A basic Cache Server application
  class CacheServer
    ##
    # @param app [#call]
    def initialize(app)
      @app = app
    end

    ##
    # @param env [Rack::Request::Env]
    def call(env)
      [200, {}, 'Hello World']
    end
  end
end
