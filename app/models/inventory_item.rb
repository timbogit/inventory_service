class InventoryItem < ActiveRecord::Base
  attr_accessible :title, :address_id, :price

  has_and_belongs_to_many :tags
  validates_presence_of :address_id, :title
end
