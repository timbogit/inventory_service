class InventoryItem < ActiveRecord::Base
  attr_accessible :title, :city_id, :price

  validates_presence_of :city_id, :title

  after_destroy :destroy_remote_tags

  def tags(refresh = false)
    @tags = RemoteTag.find_by_inventory_item_ids([id]) if refresh || !@tags
    @tags
  end

  def city(refresh = false)
    @cities = Array(RemoteCity.find_by_city_ids([city_id])) if refresh || !@cities
    @cities.first
  end

  private

  def destroy_remote_tags
    RemoteTag.destroy_tags_for_inventory_item(id, tags.map(&:name))
  end
end
