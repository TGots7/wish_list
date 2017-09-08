class WishEvent < ActiveRecord::Base
	belongs_to :wish 
	belongs_to :event
end