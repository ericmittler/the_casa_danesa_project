class UserActivity < ActiveRecord::Base
  attr_accessible :description, :user_id, :type, :more_info
end
