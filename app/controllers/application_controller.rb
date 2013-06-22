class ApplicationController < ActionController::Base
  protect_from_forgery
  force_ssl
  
  protected
  
  def ensure_authenticated
    unless logged_in?
      session[:desired_url] = request.fullpath
      redirect_to authenticate_url
    end
  end
  
  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  
end