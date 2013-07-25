class Email < ActiveRecord::Base
  attr_accessible :user_id, :address, :confirmed, :primary
  attr_reader :code
  validates_presence_of :user_id, :address
  validates_uniqueness_of :address
  validates_format_of :address, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i

  before_save :ensure_code

  belongs_to :user

  def ensure_code
    @code = ('A'..'Z').to_a[rand(26)] + "%05d" % rand(100000) if @code.blank?
  end
end
