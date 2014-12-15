class Invitation < ActiveRecord::Base
  belongs_to :thing
  belongs_to :user
end
