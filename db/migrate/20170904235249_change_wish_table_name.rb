class ChangeWishTableName < ActiveRecord::Migration[5.1]
  def change
  	rename_table :wishs, :wishes
  end
end
