class Thing < ActiveRecord::Base
  has_many :userobjects
  has_many :users, :through => :userobjects
  has_many :events
  has_many :invitations

  validates :name, length: { in: 1..25 }, presence: true
end
