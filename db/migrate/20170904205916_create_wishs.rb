class CreateWishs < ActiveRecord::Migration[5.1]
  def change
  	create_table :wishs do |t|
  		t.string :content
  		t.integer :user_id 
  	end
  end
end
