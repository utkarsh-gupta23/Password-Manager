module Users
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
    
  end
end