Rails.application.routes.draw do
  root to: "dataset#index"
  
  get Setting.uri_endpoint_route, to: 'subject#subject', constraints: {
    :format => /(#{ApplicationController.renderer_mapping.keys.join("|")})/
  }
end
