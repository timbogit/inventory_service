class RenameAddressIdToCityId < ActiveRecord::Migration
  def change
    rename_column :inventory_items, :address_id, :city_id
  end
end
