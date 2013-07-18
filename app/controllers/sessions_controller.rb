class SessionsController < ApplicationController

  def create
    user = provider = nil
    if request.fullpath == dev_login_path && Rails.env == 'development'
      user = User.find_by_email('eric_mittler@mac.com')
      provider = AuthenticationProvider.find_by_user_id_and_provider(user.id, 'developer authentication')
    else
      provider = AuthenticationProvider.from_omniauth(env['omniauth.auth'])
      user = User.find_by_id(provider.user_id) if provider && provider.user_id
    end
    session[:provider_uid] = provider.uid if provider
    if user
      UserActivity.create!(:user_id => user.id, :name => 'logged in',
                           :more_info => "ip: '#{request.ip}'\nprovider: '#{provider.provider}'")
      session[:user_id] = user.id
      url = session[:desired_url] ? session[:desired_url] : root_url
      session[:desired_url] = nil
      redirect_to url, notice: "Signed in #{user.first_name}!"
    elsif !user && provider
      redirect_to new_user_url
    else
      redirect_to authenticate_url, :alert => "Authentication failed, please try again."
    end
  end

  def destroy
    UserActivity.create!(:user_id => current_user.id, :name => 'signed out')
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end

  def failure
    redirect_to root_url, alert: "Authentication failed, please try again."
  end

  def new
  end

end
