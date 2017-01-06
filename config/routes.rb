LinkedDataFragments::Engine.routes.draw do
  root to: "dataset#index"

  get Setting.uri_endpoint_route, to: 'subject#subject', constraints: {
    :format => /(nt|ttl|jsonld)/
  }
end
