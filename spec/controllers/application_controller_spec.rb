require 'spec_helper'


class RspecTestingStubController < ApplicationController
  def some_get_method
    render :nothing => true
  end
end


describe RspecTestingStubController do
  
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
  
  
end