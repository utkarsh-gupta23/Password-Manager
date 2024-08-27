class SessionsController < ApplicationController
  # include CurrentUserConcern
  def create
     user = User.find_by(user_name: params["user_name"]).try(:authenticate, params["password"])
     
      if user
        session[:user_id] = user.id
        redirect_to credentials_path
      else
        flash[:alert] = "Invalid username or password"
        redirect_to new_session_path
      end
  end

  # def logged_in
  #   if @current_user
  #     render json: {
  #       logged_in: true,
  #       user: @current_user
  #     }
  #   else
  #     render json: {
  #       logged_in: false
  #     }
  #   end
  # end
  def logout
    reset_session
    #redirect to /login
    redirect_to new_session_path
  end
  def new

  end
  def index
    
  end
end