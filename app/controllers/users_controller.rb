class UsersController < ApplicationController
  before_filter :ensure_authenticated, :only => [:destroy, :edit]

  def create
    provider = AuthenticationProvider.find_by_uid session[:provider_uid]
    if provider.nil?
      redirect_to authenticate_url
    else
      @user = User.find_by_email(params['email']) || User.new(:email => params['email'])
      @user.first_name = params['first_name']
      @user.last_name = params['last_name']
      if @user.save
        provider.update_attributes(:user_id=>@user.id)
        redirect_to edit_user_url(@user), :notice=>'An email has been sent'
      else
        redirect_to new_user_url
      end
    end
  end

  def destroy
    render :text => 'delete unimplemented'
  end

  def index
    render :text => 'index unimplemented'
  end

  def edit
    provider = AuthenticationProvider.find_by_uid(session[:provider_uid])
    @user = provider.user
  end

  def new
    @user = User.new
  end

  def update
    render :text => 'update unimplemented'
  end
end