class CreateEvents < ActiveRecord::Migration[5.1]
  def change
  	create_table :events do |t|
  		t.string :event
  		t.integer :wish_id 
  	end
  end
end
