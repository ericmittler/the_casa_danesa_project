TheCasaDanesaProject::Application.routes.draw do

  # Home & Root
  root :to => "home#index"
  get "home", to: 'home#index'
  
  # Authentication
  get '/sessions/new', to: 'sessions#new'
  match "/auth/:provider/callback", to: "sessions#create"
  match "/auth/developer", to: 'sessions#create', :as => 'dev_login'
  match "/auth/failure", to: "sessions#failure"
  match "/logout", to: "sessions#destroy", :as => "logout"
  
  # Resources
  resources :events

  if Rails.env.test?
    namespace :rspec_testing_stub do
      get 'some_get_method', :action => :some_get_method
    end
  end

end
