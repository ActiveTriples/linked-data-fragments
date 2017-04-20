Rails.application.routes.draw do
  root to: "dataset#index"
  
  get Setting.uri_endpoint_route, to: 'subject#subject', constraints: {
    :format => /(#{ApplicationController.renderer_mapping.keys.join("|")})/
  }

  get 'ldf', to: 'subject#query', constraints: {
      :format => /(#{ApplicationController.renderer_mapping.keys.join("|")})/
  }



=begin
  root to: "dataset#index", :constraints => RootConstraint.new

  get Setting.uri_endpoint_route, to: 'subject#subject', :constraints => SubjectConstraint.new

  get Setting.uri_query_route, to: 'subject#query', :constraints => QueryConstraint.new
=end
end
