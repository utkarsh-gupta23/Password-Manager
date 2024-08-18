class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :display_name, :email])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username, :email])
  end

    def after_sign_in_path_for(resource)
      credentials_path
    end
  
    def email_required?
      false
    end

end
