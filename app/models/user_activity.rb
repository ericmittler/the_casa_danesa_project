class UserActivity < ActiveRecord::Base
  attr_accessible :description, :user_id, :name, :more_info
  belongs_to :user
end
