require 'spec_helper'

describe SessionsController do
  describe 'GET new' do
    it 'should render the new template'
  end
  
  describe 'DELETE destroy' do
    it 'should log user the sign out'

    it 'should delete the session'
    
    it 'should redirect to the root_url with a "Signed Out" notice'
  end

  describe 'GET failure' do
    it 'should redirect to root_url and alert "Authentication Failed"'
  end
end