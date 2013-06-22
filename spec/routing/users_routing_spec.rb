require 'spec_helper'

describe UsersController do
  describe 'routing' do
    it 'routes to #create'
    it 'routes to #delete'
    it 'routes to #index'

    it 'routes to #new' do
      get('/users/new').should route_to('users#new')
    end

    it 'routes to #update'
  end
end
