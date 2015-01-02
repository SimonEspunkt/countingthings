class Invitation < ActiveRecord::Base
  belongs_to :thing
  belongs_to :user

  validates :recipient_email, length: { in: 3..255 }, presence: true, email: true
end
