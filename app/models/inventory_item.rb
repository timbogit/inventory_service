class InventoryItem < ActiveRecord::Base
  attr_accessible :title, :address_id

  has_and_belongs_to_many :inventory_item_tags
  validates_presence_of :address_id, :title
end