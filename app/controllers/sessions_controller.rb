class SessionsController < ApplicationController

  def create
    user = provider = nil
    if request.fullpath == dev_login_path && ENV['RAILS_ENV'] == 'development'
      provider = "developer login"
      user = User.find_by_email('eric_mittler@mac.com')
    else
      provider = AuthenitcationProvider.from_omniauth(env['omniauth.auth'])
    #   user = User.find_or_create_by_uid(provider.user_id)
    end
    if user
    #   UserActivity.create!(:user_id=>user.id, :name=>'logged in',
    #     :more_info => "ip: '#{request.ip}'\nprovider: '#{provider}'")
    #   session[:user_id] = user.id
    #   url = session[:desired_url] ? session[:desired_url] : root_url
    #   redirect_to url, notice: "Signed in #{user.aka}!"
    end
    render :text => env['omniauth.auth']
  end

  def destroy
    UserActivity.create!(:user_id=>current_user.id, :name=>'signed out')
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end

  def failure
    redirect_to root_url, alert: "Authentication failed, please try again."
  end
  
  def new
  end
  
end
