class SessionsController < ApplicationController

  def create
    provider = if request.fullpath == dev_login_path && Rails.env == 'development'
                 AuthenticationProvider.where(:provider => 'developer authentication').first
               else
                 AuthenticationProvider.from_omniauth(env['omniauth.auth'])
               end
    session[:provider_uid] = provider.uid if provider
    if provider
      if provider.user
        session[:user_id] = provider.user.id
        UserActivity.create!(:user_id => provider.user.id, :name => 'logged in',
                             :more_info => "ip: '#{request.ip}'\nprovider: '#{provider.provider}'")
        url = session[:desired_url] ? session[:desired_url] : root_url
        session[:desired_url] = nil
        redirect_to url, notice: "#{provider.user.first_name} authenticated via #{provider.provider}"
      else
        redirect_to new_user_url
      end
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
