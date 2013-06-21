require 'spec_helper'


class RspecTestingStubController < ApplicationController
  def some_get_method
    render :nothing => true
  end
end


describe RspecTestingStubController do
  
  let(:user) { FactoryGirl.create(:user) }
  
  describe 'force_ssl' do
    it 'should not be successful when ssl is on' do
      request.env['HTTPS'] = 'on'
      get :some_get_method
      response.should be_successful
    end
    
    it 'should not be successful when ssl is off' do
      request.env['HTTPS'] = 'off'
      get :some_get_method
      response.should_not be_successful
    end
  end
    
  describe 'current_user' do
    context 'when user logged in' do
      it 'should return the current_user' do
        session[:user_id] = user.id
        controller.send(:current_user).should == user
      end
    end
    
    context 'when no user is logged in' do
      it 'should return nil' do
        session[:user_id] = nil
        controller.send(:current_user).should == nil
      end
    end
  end
  
  describe 'logged_in?' do
    it 'should return true when a user has authenticated' do
      session[:user_id] = user.id
      controller.send(:logged_in?).should be_true
    end
    
    it 'should return false when a user has no authenticated' do
      session[:user_id] = nil
      controller.send(:logged_in?).should be_false
    end
  end
end