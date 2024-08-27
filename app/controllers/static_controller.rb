class StaticController < ApplicationController
  include CurrentUserConcern
  def origin
      #redirect to /credentials if user is logged in
    if @current_user
      redirect_to credentials_path
    else
      #redirect to /login if user is not logged in
      redirect_to new_session_path
    end
  end
end