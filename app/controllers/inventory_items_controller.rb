class InventoryItemsController < ApplicationController

  def show
    # TODO: this is where we would usually fall back to the service call to the
    #       to-be-implemented API Pipeline to get the Locale in the latest version;
    #       for now, just return a 404
    not_found_with_max_age(caching_time) and return unless (@item = InventoryItem.find(params[:id]))
    Rails.logger.debug "Inventory Item with ID #{@item.id} is #{@item.inspect}"

    render_if_stale(@item, last_modified: @item.updated_at.utc, etag: @item) do |item_presenter|
      item_presenter.hash
    end
    # explicitly setting the Cache-Control response header to public and max-age, to make the response cachable by proxy caches
    expires_in caching_time, public: true
  end

  # # Create a new entity.
  # #
  # # Subclasses MUST implement:
  # #
  # # - entity_hash_class: an Entity::EntityHash subclass that validates the data
  # # hash the entity is created from
  # # - entity_class: a model class that includes Entity
  # #
  # # Subclasses MAY override:
  # #
  # # - params_for_entity: should extract the root of the data hash to creat the
  # # entity from the request parameters
  # # - id_from_params: should extract the object's ID from the request
  # # parameters
  # # - key_for_entity: should convert the object's ID to a dealstore key
  # #
  # def create
  #   # validate the entity based on the incoming params hash
  #   entity_hash = entity_hash_class.new(params_for_entity)
  #   render(json: entity_hash.errors, status: :unprocessable_entity) and return unless entity_hash.valid?
  #   # update an existing entity
  #   if @entity = entity_class.find_by_key(key_for_entity(id_from_params))
  #     if @entity.update_collection(remove_root_element_from_json_string(entity_class.name.downcase, request.body.read), params[:version])
  #       Rails.logger.debug "Updated #{entity_class} is #{@entity.inspect}"
  #       head :no_content
  #     else
  #       Rails.logger.error "cannot update because there were errors saving #{@entity.attributes.inspect} ... #{@entity.errors.to_hash}"
  #       render(json: @entity.errors, status: :unprocessable_entity) and return
  #     end
  #   else # create a new entity
  #     @entity = entity_class.init_from_params(remove_root_element_from_json_string(entity_class.name.downcase, request.body.read), params[:version], key_for_entity(id_from_params))
  #     if @entity.save
  #       render text: '{"success": true}', status: :created, location: entity_path(params[:version], @entity.data_id)
  #     else
  #       Rails.logger.error "cannot create because there were errors saving #{@entity.attributes.inspect} ... #{@entity.errors.to_hash}"
  #       render(json: @entity.errors, status: :unprocessable_entity) and return
  #     end
  #   end
  # end

  # private

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
