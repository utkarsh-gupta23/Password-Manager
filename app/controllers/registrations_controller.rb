class RegistrationsController < ApplicationController
  include CurrentUserConcern
  def create
    user = User.create!(user_name: params['user_name'], display_name:params['display_name'],password: params['password'], password_confirmation: params['password_confirmation'])

    if user
      session[:user_id] = user.id
      redirect_to new_session_path
    else
      render json: {status: 500}
    end
    rescue ActiveRecord::RecordInvalid => e
      render json: { status: 500, error: e.message }
  end
  def new
    
  end
  def index
    
  end
  def update
    if BCrypt::Password.new(@current_user.password_digest) == params["password"]
      @current_user.update(
        user_name: params[:user_name]
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
     redirect_to credentials_path
    else
      error!({ status: 422, message: @current_user.errors.full_messages }, 422)
    end
  end
end