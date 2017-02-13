Rails.application.routes.draw do
  root to: "dataset#index"

  resources :dataset, :get

  get "/dataset/:dataset/#{LinkedDataFragments::Settings.uri_endpoint_route}",
      to: 'subject#subject',
      constraints: { format: /(#{ApplicationController.renderer_mapping.keys.join("|")})/ }

  get LinkedDataFragments::Settings.uri_endpoint_route,
      to: 'subject#subject',
      constraints: { format: /(#{ApplicationController.renderer_mapping.keys.join("|")})/ }
end
