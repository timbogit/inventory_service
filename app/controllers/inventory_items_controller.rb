class InventoryItemsController < ApplicationController
  before_action :find_item, except: [:create, :index]

  # Show a single inventory_item
  def show
    Rails.logger.debug "Inventory Item with ID #{@item.id} is #{@item.inspect}"

    render_if_stale(@item, last_modified: @item.updated_at.utc, etag: @item) do |item_presenter|
      item_presenter.hash
    end
    # explicitly setting the Cache-Control response header to public and max-age, to make the response cachable by proxy caches
    expires_in caching_time, public: true
  end

  # List all inventory_items
  def index
    all_items = InventoryItem.all
    return json_response([]) unless newest_item = all_items.sort_by(&:updated_at).first
    Rails.logger.info "newest_item is #{newest_item.inspect}"
    render_if_stale(all_items, last_modified: newest_item.updated_at.utc, etag: newest_item) do |item_presenters|
      item_presenters.map(&:hash)
    end
    # explicitly setting the Cache-Control response header to public and max-age, to make the response cachable by proxy caches
    expires_in caching_time, public: true
  end

  # Create a new inventory_item (with associated tags).
  # Example:
  #  ` curl -v -H "Content-type: application/json" -X POST 'http://localhost:3000/api/v1/inventory_items.json' \
  #         -d '{"price":5.88, "title":"Bens stickers", "address_id": 1234}'`
  def create
    item = InventoryItem.new(params.slice(:title, :price, :address_id))
    if item.save
      render text: '{"success": true}', status: :created, location: inventory_item_path(params[:version], item.id)
    else
      Rails.logger.error "cannot create because there were errors saving #{item.attributes.inspect} ... #{item.errors.to_hash}"
      render(json: item.errors, status: :unprocessable_entity)
    end
  end

  # Update an existing inventory_item.
  # Example:
  #  `curl -v -H "Content-type: application/json" -X PUT 'http://localhost:3000/api/v1/inventory_items/1.json' \
  #         -d '{"price":5.88, "title":"Bens stickers", "address_id": 1234}'`
  def update
    if @item.update(params.slice(:title, :price, :address_id))
      render text: '{"success": true}', status: :no_content, location: inventory_item_path(params[:version], @item.id)
    else
      Rails.logger.error "cannot update inventory item because there were errors saving #{@item.attributes.inspect} ... #{@item.errors.to_hash}"
      render(json: @item.errors, status: :unprocessable_entity)
    end
  end

  # Delete an inventory item
  # Example:
  #  `curl -v -H "Content-type: application/json" -X DELETE 'http://localhost:3000/api/v1/inventory_items/1.json'`
  def destroy
    if @item.destroy
      render text: '{"success": true}', status: :no_content, location: inventory_item_path(params[:version], @item.id)
    else
      Rails.logger.error "cannot destroy inventory item because there were errors deleting the item #{@item.attributes.inspect} ... #{@item.errors.to_hash}"
      render(json: @item.errors, status: :bad_request)
    end
  end

  private

  def find_item
    not_found_with_max_age(caching_time) and return unless (@item = InventoryItem.find_by(params.slice(:id)))
  end

  # # Extract the object's upstream (e.g. city ID or deal ID) from the data hash
  # # parameter
  # def id_from_params
  #   params_for_entity[:id]
  # end

  # # Generates an entity key given an upstream ID or raises ApplicationController::BadParameters
  # def key_for_entity(id)
  #   entity_class.key_for_id(id)
  # rescue ArgumentError, TypeError
  #   raise ApplicationController::BadParameters.new("'id' parameter needs to be a positive integer")
  # end

  # # Extracts the data hash for the created entity from the request parameters
  # def params_for_entity
  #   params[entity_class.name.downcase.to_sym]
  # end

  # # Generate the URL for the specified API version and object ID
  # def entity_path(version, id)
  #   send "#{entity_class.name.downcase}_path", version, id
  # end

end
