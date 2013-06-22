class AuthenitcationProvider < ActiveRecord::Base
  attr_accessible :provider, :uid, :info, :extra, :user_id
  validates :provider, :uid, :presence => true
  
  belongs_to :user
  
  def self.from_omniauth(auth)
    provider = where(auth.slice('provider', 'uid')).first || create_from_omniauth(auth)
    provider.update_attributes(
      :info => auth['info'].to_yaml, 
      :extra => auth['extra'].to_yaml)
    provider
  end
  
  def self.create_from_omniauth(auth)
    create! do |provider|
      provider.provider = auth["provider"]
      provider.uid = auth["uid"]
    end
  end
end
