class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #before_action :configure_permitted_parameters, if: (:devise_controller? or :user_controller?)
  before_action :configure_permitted_parameters, if: :devise_controller?


  add_flash_types :error, :success

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:agent_number, :name, :address, :email, :password, :password_confirmation) }
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :agent_number, :email, :password) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:agent_number, :name, :address, :email, :password, :password_confirmation, :current_password) }
    end

end  
