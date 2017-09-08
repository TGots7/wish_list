class CreateWishEvents < ActiveRecord::Migration[5.1]
  def change
  	create_table :wish_events do |t|
  		t.integer :event_id
  		t.integer :wish_id 
  	end
  end
end
