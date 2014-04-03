class DropTagsAndInventoryItemTags < ActiveRecord::Migration
  def up
    drop_table :inventory_items_tags
    drop_table :tags
  end

  def down
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end

    create_table :inventory_items_tags do |t|
      t.belongs_to :inventory_item
      t.belongs_to :tag

      t.timestamps
    end
  end
end
