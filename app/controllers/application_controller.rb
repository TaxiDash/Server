class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery
  before_action :authenticate_user!, :unless => [:json_request?]
  #skip_before_action :verify_authenticity_token, if: :json_request?
  before_filter :configure_permitted_parameters, if: :devise_controller?

  # This is a CanCan workaround as described at 
  # https://github.com/ryanb/cancan/issues/835#issuecomment-18663815
  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  def configure_permitted_parameters
        devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :username, :email, :password, :password_confirmation) }
        devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:first_name, :last_name, :username, :email, :password, :password_confirmation) }
  end

  #rescue_from CanCan::AccessDenied do |exception|
      #flash[:error] = exception.message
      #redirect_to root_url
  #end

  protected

  def json_request?
      request.format.json?
  end

end
