class Userobject < ActiveRecord::Base
  belongs_to :user
  belongs_to :thing, counter_cache: true
end
