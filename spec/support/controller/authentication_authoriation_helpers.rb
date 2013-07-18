
  def authenticate_for_specs(user)
    user = FactoryGirl.create(:user) if user.nil?
    session[:user_id] = user.id
    user
  end