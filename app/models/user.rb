class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :event_manager, :email_validated, :aka
  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i

  has_many :authentication_providers
end
