class Presenters::V1::InventoryItemPresenter < ::Presenter
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper
  include Rails.application.routes.url_helpers

  attr_accessor :inventory_item

  IMAGE_URLS = [
    "https://a1.lscdn.net/imgs/6c2f477a-641b-4c0b-b97a-d060ead12ec1/540_q80.jpg",
    "https://a1.lscdn.net/imgs/6690de55-2c23-4e24-9bb5-1e745271d7a8/540_q80.jpg",
    "https://a1.lscdn.net/imgs/bc79d164-3ab6-4223-9404-39f67f85a030/540_q80.jpg",
    "https://a1.lscdn.net/imgs/0402309c-cedb-4f72-afba-8a3ea0173099/540_q80.jpg",
    "https://a0.lscdn.net/imgs/041c0679-ed59-48b7-9380-e5759495adac/540_q80.jpg",
    "https://a0.lscdn.net/imgs/faaffeb3-ec62-4ed9-b5d7-4aa049a3f7de/540_q80.jpg",
    "https://a0.lscdn.net/imgs/4666a90c-9ce7-4c1a-a838-7039a8dd5bde/540_q80.jpg",
    "https://a0.lscdn.net/imgs/168a2f0b-1663-4c75-af1d-6c8dc5592d6a/540_q80.jpg",
    "https://a1.lscdn.net/imgs/5c161267-3fd7-4146-b8da-03e810029f80/540_q80.jpg",
    "https://a0.lscdn.net/imgs/b286fd13-c9b0-4c66-90f7-3c20aaa22f9d/540_q80.jpg",
  ]

  def initialize(item)
    @inventory_item = item
    super(@inventory_item)
  end

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
