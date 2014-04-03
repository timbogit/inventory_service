class Presenters::V1::InventoryItemPresenter < ::Presenter
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper
  include Rails.application.routes.url_helpers

  attr_accessor :inventory_item

  def initialize(item)
    @inventory_item = item
    super(@inventory_item)
  end

  def to_hash(item = inventory_item)
    HashWithIndifferentAccess.new({
                                    full_title:   item.title,
                                    short_title:  truncate(item.title, length: 15),
                                    usd:          number_to_currency(item.price, :unit => "$"),
                                    path:         inventory_item_path(self.class.version_number, item.id),
                                    tags:         item.tags.map(&:name)
                                  })
  end
end
