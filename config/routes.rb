Rails.application.routes.draw do

  mount Credentials::Base => '/'
  mount Users::Base => '/'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  resources :sessions
  # Defines the root path route ("/")
  get "credentials/search" , to: "credentials#search"
  resources :credentials
  #for creating users.
  resources :registrations
  post "login" , to: "sessions#create"
  post "signup" , to: "registrations#create"
  get "editProfile" , to: "registrations#editProfile"
  root "static#origin"
  delete "logout" , to: "sessions#logout"
end
