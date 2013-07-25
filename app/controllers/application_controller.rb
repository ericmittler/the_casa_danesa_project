class ApplicationController < ActionController::Base
  protect_from_forgery
  force_ssl

  protected

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def ensure_authenticated
    if logged_in?
      true
    else
      session[:desired_url] = request.fullpath
      redirect_to authenticate_url
      false
    end
  end

  def ensure_registered
    ensure_authenticated
    unless current_user.nil? or current_user.registered?
      redirect_to edit_user_url(current_user.id)
    end
  end

  def logged_in?
    !!current_user
  end

  helper_method :current_user

end