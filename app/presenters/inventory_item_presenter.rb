class InventoryItemPresenter < ::Presenter
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper
  include Rails.application.routes.url_helpers

  ITEM_REPRESENTATIONS = [:full]
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

  attr_accessor :inventory_item

  def initialize(item)
    @inventory_item = item
    super(@inventory_item)
  end
end
