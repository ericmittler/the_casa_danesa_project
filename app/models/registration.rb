class Registration < ActiveRecord::Base
  attr_accessible :user_id
  attr_reader :code
  before_save :ensure_code
  validates_presence_of :user_id
  belongs_to :user

  def ensure_code
    @code = UUIDTools::UUID.timestamp_create.to_s if code.blank?
  end
end
