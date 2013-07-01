require 'spec_helper'

describe UsersController do
  describe 'routing' do
    it 'routes to #create' do
      post('/users').should route_to('users#create')
    end

    it 'routes to #delete'

    it 'routes to #index'

    it 'routes to #new' do
      get('/users/new').should route_to('users#new')
    end

    it 'routes to #edit' do
      get('/users/XXX/edit').should route_to('users#edit', :id=> 'XXX')
    end

    it 'routes to #update'
  end
end
