TheCasaDanesaProject::Application.routes.draw do

  # Home & Root
  root :to => "home#index"
  get "home/index"
  
  # Authentication
  resources :sessions
  match "/auth/:provider/callback", to: "sessions#create"
  match "/auth/developer", to: 'sessions#create', :as => 'dev_login'
  match "/auth/failure", to: "sessions#failure"
  match "/logout", to: "sessions#destroy", :as => "logout"
  
  # Resources
  resources :events
  resources :identities

end
