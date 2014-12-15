class Event < ActiveRecord::Base
  belongs_to :thing, counter_cache: true
end
