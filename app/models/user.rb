class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :aka, :event_manager, :email_validated
  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i

  has_many :authentication_providers


  def aka
    read_attribute(:aka).blank? ? "#{full_name}" : read_attribute(:aka)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def registered?
    email_validated && !first_name.blank? && !last_name.blank? && !email.blank?
  end
end
