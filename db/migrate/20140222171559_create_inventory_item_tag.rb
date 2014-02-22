class CreateInventoryItemTag < ActiveRecord::Migration
  def change
    create_table :inventory_item_tags do |t|
      t.integer :inventory_item_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
