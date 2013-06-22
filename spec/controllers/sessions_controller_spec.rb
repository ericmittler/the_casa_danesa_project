require 'spec_helper'

describe SessionsController do
  let(:user) { FactoryGirl.create(:user) }
  
  before :each do
    request.env['HTTPS'] = 'on'
  end

  describe 'GET new' do
    it 'should render the new template' do
      get :new
      response.should be_success
      response.should render_template :new
    end
  end
  
  describe 'DELETE destroy' do
    before :each do 
      session[:user_id] = user.id
    end
    
    it 'should log user the sign out' do
      expect {
        delete :destroy
      }.to change(UserActivity, :count).by(1)
      a = UserActivity.last
      a.user_id.should == user.id
      a.name.should == 'signed out'
    end

    it 'should delete the session' do
      delete :destroy
      session[:user_id].should be_nil
      controller.send(:current_user).should be_nil
      controller.send(:logged_in?).should be_false
    end
    
    it 'should redirect to the root_url with a "Signed Out" notice' do
      delete :destroy
      response.should redirect_to root_url
      flash[:notice].downcase.should include('signed out')
    end
  end

  describe 'GET failure' do
    before :each do 
      session[:user_id] = user.id
    end
    
    it 'should redirect to root_url and alert "Authentication Failed"' do
      get :failure
      response.should redirect_to root_url
      flash[:alert].downcase.should include('authentication failed')
    end
  end
end