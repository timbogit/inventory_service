class Presenters::V1::InventoryItemPresenter < ::Presenter
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper

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
                                    tags:         item.tags.map(&:name)
                                  })
  end
end
