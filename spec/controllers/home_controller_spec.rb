require 'spec_helper'

describe HomeController do
  
  before :each do
    request.env['HTTPS'] = 'on'
  end

  describe "GET 'index'" do
    it "returns http success" do     
      get 'index'
      response.should be_success
    end
  end

end
