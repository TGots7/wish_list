class Event < ActiveRecord::Base
	has_many :wish_events
	has_many :wishes, through: :wish_events
end