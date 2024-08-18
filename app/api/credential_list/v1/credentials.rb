module CredentialList
  module V1
    class Credentials < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api
      resources :credentials do
        
        desc 'Return list of books'
        get do
          User.all
        end
      end
    end
  end
end
