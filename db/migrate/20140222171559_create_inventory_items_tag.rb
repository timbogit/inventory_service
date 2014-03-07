class CreateInventoryItemsTag < ActiveRecord::Migration
  def change
    create_table :inventory_items_tags do |t|
      t.belongs_to :inventory_item
      t.belongs_to :tag

      t.timestamps
    end
  end
end
