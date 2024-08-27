module Test
  class Base < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api

    helpers do
      def set_current_user
        #if current user is nil, then send error response
        if env['rack.session'][:user_id]
          @current_user = User.find(env['rack.session'][:user_id])  
        else
          error!('Unauthorized', 401)
        end 

        def current_user
          @current_user
        end
      end
    end

    resources :sessions do
      desc "Login route" 
      post do
        user = User.find_by(user_name: params["user"]["user_name"])
      
        if user && user.authenticate(params["user"]["password"])
          # User is authenticated and valid

          env['rack.session'][:user_id] = user.id
          {
            status: :created,
            logged_in: true,
            user: user
          }
        elsif user
          # User exists but authentication failed
          error!({ status: 401, message: "Invalid password" }, 401)
        else
          # User does not exist
          error!({ status: 401, message: "User does not exist" }, 401)
        end
      end
    end

    resources :registrations do

      desc "Register a new user" 
      post do
        # p params
        user = User.create(
          user_name: params['user']['user_name'],
          password: params['user']['password'],
          password_confirmation: params['user']['password_confirmation'],
          display_name: params['user']['display_name']
        )
        if user.valid?
          env['rack.session'][:user_id] = user.id
          # p env['rack.session']
          {
            status: :created,
            user: user
          }
        else
          error!({ status: 500, message: user.errors.full_messages }, 500)
        end
      end

      before { set_current_user }

      desc 'Update current user details'
      params do
        requires :user_name, type: String, desc: 'New username'
        requires :password, type: String, desc: 'New password'
        requires :display_name, type: String, desc: 'New display name'
        optional :new_password, type: String, desc: 'New password'
      end

      put do
        if BCrypt::Password.new(@current_user.password_digest) == params["password"]
          @current_user.update(
            user_name: params[:user_name],
            display_name: params[:display_name]
          )
          if params["new_password"] && params["new_password"].length > 0
            @current_user.update(
              password: params["new_password"]
            )
          end
        else
          error!({status: 401, message: "Invalid password"}, 401)
        end

        if @current_user.save
          { status: :updated, user: @current_user }
        else
          error!({ status: 422, message: @current_user.errors.full_messages }, 422)
        end
      end
    end
    
    #for credentials - get, post, edit, delete
    resources :credentials do
      before { set_current_user }

      desc "Return all credentials of the current user"
      get  do
        Credential.where(user_id: current_user.id).order(created_at: :desc)
      end


      desc "Create a new credential"
      post do
        credential = Credential.create(
          user_id: current_user.id ,
          title:params['credential']['title'] ,
          username:params['credential']['username'], 
          password:params['credential']['password'], 
          website:params['credential']['website'], 
        )
        if credential.valid?
          {
            status: :created,
            credential: credential
          }
        else
          error!({ status: 500, message: credential.errors.full_messages }, 500)
        end
      end

      desc 'Update a credential'
      params do
        requires :id, type: Integer, desc: 'Credential ID'
        optional :title, type: String, desc: 'Credential title'
        optional :username, type: String, desc: 'Username'
        optional :password, type: String, desc: 'Password'
        optional :website, type: String, desc: 'Website'
      end
      put ':id' do
        id = params[:id].to_i
        credential = Credential.find_by(id: id, user_id: current_user.id)
        
        if credential
          if credential.update(declared(params, include_missing: false))
            { status: :updated, message: "Credential updated", credential: credential }
          else
            error!({ status: 422, message: "Unable to update credential", errors: credential.errors.full_messages }, 422)
          end
        else
          error!({ status: 404, message: "Credential not found" }, 404)
        end
      end

      desc 'Delete a credential'
      params do
        requires :id, desc: 'Credential ID'
      end
      delete ':id' do
        id = params[:id].to_i
        credential = Credential.find_by(id: id, user_id: current_user.id)
        deleted = credential
        if credential
          credential.destroy
          { status: :deleted, message: "Credential deleted" , credential: deleted}
        else
          error!({ status: 404, message: "Credential not found" }, 404)
        end
      end

    end
  end
end