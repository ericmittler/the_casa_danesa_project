require 'spec_helper'


class RspecTestingStubController < ApplicationController
  before_filter :ensure_authenticated, :except => :some_other_get_method
  before_filter :ensure_registered

  def some_get_method
    render :text => 'successfully rendered some_get_method'
  end

  def some_other_get_method
    render :text => 'successfully rendered some_other_get_method'
  end
end


describe RspecTestingStubController do

  let(:user) { FactoryGirl.create(:user) }

  describe 'force_ssl' do
    before :each do
      session[:user_id] = user.id
    end

    it 'should not be successful when ssl is on' do
      request.env['HTTPS'] = 'on'
      get :some_get_method
      response.should be_successful
      response.body.should == 'successfully rendered some_get_method'
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

  describe 'ensure_authenticated' do
    before :each do
      request.env['HTTPS'] = 'on'
    end

    context 'when user has authenticated' do
      it 'should do nothing and allow expected template to render' do
        session[:user_id] = user.id
        get :some_get_method
        response.should be_successful
        response.body.should == 'successfully rendered some_get_method'
      end
    end

    context 'when user has not authenticated' do
      before :each do
        session[:user_id] = nil
      end

      it 'should redirect to authenticate_url' do
        get :some_get_method
        response.should redirect_to authenticate_url
      end

      it 'should remember the desired_url' do
        session[:desired_url] = 'this should be replaced'
        get :some_get_method
        session[:desired_url].should == '/rspec_testing_stub/some_get_method'
      end
    end
  end

  describe 'ensure_registered' do
    before :each do
      request.env['HTTPS'] = 'on'
    end

    it 'should ensure_authenticated' do
      controller.should_receive(:ensure_authenticated)
      get :some_other_get_method
    end

    it 'should do nothing for a valid user' do
      session[:user_id] = user.id
      get :some_other_get_method
      response.should be_successful
      response.body.should == 'successfully rendered some_other_get_method'
    end

    it 'should redirect to edit_user_url if email_validated is false' do
      user = FactoryGirl.create(:user, :email_validated=>false)
      session[:user_id] = user.id
      get :some_other_get_method
      response.should redirect_to edit_user_url(user.id)
    end

    it 'should do nothing if email_validated is true' do
      user = FactoryGirl.create(:user, :email_validated=>true)
      session[:user_id] = user.id
      get :some_other_get_method
      response.should be_successful
      response.body.should == 'successfully rendered some_other_get_method'
    end


  end
end