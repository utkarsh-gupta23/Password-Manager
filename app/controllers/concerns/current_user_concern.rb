module CurrentUserConcern

  #provide included keyword
  extend ActiveSupport::Concern

  #run this code whenever this particular module is included within any class
  included do 
    before_action :set_current_user
  end

  def set_current_user
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    end
  end
end