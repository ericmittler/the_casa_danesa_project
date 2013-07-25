class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :aka, :event_manager
  has_many :authentication_providers
  has_many :emails

  def aka
    read_attribute(:aka).blank? ? "#{full_name}" : read_attribute(:aka)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def primary_email
    if emails.length == 1
      emails.first
    elsif emails.length > 1
      found = emails.select { |e| e.primary? }
      found.length > 0 ? found[0] : emails.first
    end
  end

  def registered?
    !first_name.blank? && !last_name.blank? && !primary_email.nil? && primary_email.confirmed?
  end

  def self.find_by_email(address)
    email = Email.find_all_by_address(address).first
    email.nil? ? nil : email.user
  end
end
