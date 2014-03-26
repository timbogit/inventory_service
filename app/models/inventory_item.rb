class InventoryItem < ActiveRecord::Base
  attr_accessible :title, :address_id, :price

  validates_presence_of :address_id, :title

  def tags(refresh = false)
    @tags = RemoteTag.find_by_inventory_item_ids([id]) if refresh || !@tags
    @tags
  end
end
