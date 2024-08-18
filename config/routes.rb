Rails.application.routes.draw do
  mount CredentialList::Base => '/'
  get "/credentials/search", to: "credentials#search"  # create new,  usually a submitted form
  resources :credentials
  devise_for :users 
  root "home#index"
end
