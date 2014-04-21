class Presenters::V1::FullInventoryItemPresenter < ::InventoryItemPresenter

  def to_hash(item = inventory_item)
    HashWithIndifferentAccess.new({
                                    full_title:   item.title,
                                    short_title:  truncate(item.title, length: 15),
                                    image_url:    IMAGE_URLS[item.id % IMAGE_URLS.size],
                                    usd:          number_to_currency(item.price, :unit => "$"),
                                    city:         { id: item.city_id, name: item.city.name },
                                    path:         inventory_item_path(self.class.version_number, item.id),
                                    tags:         item.tags.map(&:name)
                                  })
  end

end
