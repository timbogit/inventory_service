class CreateInventoryItem < ActiveRecord::Migration
  def change
    create_table :inventory_items do |t|
      t.string :title
      t.decimal :price
      t.integer :address_id

      t.timestamps
    end
  end
end
