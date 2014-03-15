class Presenters::V1::TagPresenter < ::Presenter
  include ActionView::Helpers::TextHelper

  attr_accessor :tag

  def initialize(item)
    @tag = item
    super(@tag)
  end

  def to_hash(item = tag)
    HashWithIndifferentAccess.new(
    {
      name:   tag.name,
      tagged_items: {
        count: tag.inventory_items.count,
        items: tag.inventory_items.map do |item|
                 { type: item.class.name,
                   id: item.id }
               end
      }
    })
  end
end
