class Wish < ActiveRecord::Base
	belongs_to :user
	has_many :wish_events
	has_many :events, through: :wish_events
end