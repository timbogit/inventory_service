class Presenters::V1::InventoryItemPresenter < ::InventoryItemPresenter

  def to_hash(item = inventory_item)
    HashWithIndifferentAccess.new({
                                    full_title:   item.title,
                                    short_title:  truncate(item.title, length: 15),
                                    image_url:    IMAGE_URLS[item.id % IMAGE_URLS.size],
                                    usd:          number_to_currency(item.price, :unit => "$"),
                                    city_uri:     "http://#{RemoteCity.host}/api/v#{RemoteCity.api_version}/#{RemoteCity.resources}/#{item.city_id}",
                                    path:         inventory_item_path(self.class.version_number, item.id),
                                    tags_uri:     "http://#{RemoteTag.host}/api/v#{RemoteTag.api_version}/#{RemoteTag.resources}?item_id=#{item.id}"
                                  })
  end

end
