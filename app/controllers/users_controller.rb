class UsersController < ApplicationController
  before_filter :ensure_authenticated, :only => [:destroy, :edit]

  def create
    provider = AuthenticationProvider.find_by_uid session[:provider_uid]
    email = Email.find_by_address(params['email'])
    if provider.nil?
      redirect_to authenticate_url
    elsif provider.user
      redirect_to edit_user_url(provider.user)
    elsif email
      redirect_to new_user_url, :notice => 'The email provided is already associated with another user.'
    else
      @user = User.create(:first_name => params['first_name'],
                          :last_name => params['last_name'])
      @user.emails.create(:address => params['email'], :primary => true)
      provider.update_attributes(:user_id => @user.id)
      redirect_to edit_user_url(@user)
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