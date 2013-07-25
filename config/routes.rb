TheCasaDanesaProject::Application.routes.draw do

  # Home & Root
  root :to => "home#index"
  get "home", to: 'home#index'
  
  # Authentication
  get '/sessions/new', to: 'sessions#new', :as => 'authenticate'
  match "/auth/:provider/callback", to: "sessions#create"
  match "/auth/developer", to: 'sessions#create', :as => 'dev_login'
  match "/auth/failure", to: "sessions#failure"
  match "/logout", to: "sessions#destroy", :as => "logout"
  
  # Resources
  resources :events
  resources :users

  if Rails.env.test?
    namespace :rspec_testing_stub do
      get 'some_method_requiring_registration', :action => :some_method_requiring_registration
      get 'some_method_not_requiring_registration', :action => :some_method_not_requiring_registration
      get 'some_method_requiring_authentication_only', :action => :some_method_requiring_authentication_only
    end
  end

end
