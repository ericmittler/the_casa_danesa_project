class AuthenitcationProvider < ActiveRecord::Base
  attr_accessible :provided_data, :provider_name, :uid
end
