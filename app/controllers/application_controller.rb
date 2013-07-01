class ApplicationController < ActionController::Base
  protect_from_forgery
  force_ssl

  protected

  def ensure_registered
    ensure_authenticated
    if logged_in? && !current_user.email_validated?
      redirect_to edit_user_url(current_user.id)
    end
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

  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

end