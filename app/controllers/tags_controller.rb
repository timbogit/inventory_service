class TagsController < ApplicationController
  # Show a single tag
  def show
    not_found_with_max_age(caching_time) and return unless (@tag = Tag.find(params[:id]))
    Rails.logger.debug "Inventory Item with ID #{@tag.id} is #{@tag.inspect}"

    render_if_stale(@tag, last_modified: @tag.updated_at.utc, etag: @tag) do |tag_presenter|
      tag_presenter.hash
    end
    # explicitly setting the Cache-Control response header to public and max-age, to make the response cachable by proxy caches
    expires_in caching_time, public: true
  end

  # List all tags
  def index
    all_tags = Tag.all
    return json_response([]) unless newest_tag = all_tags.sort_by(&:updated_at).first
    Rails.logger.info "newest_tag is #{newest_tag.inspect}"
    render_if_stale(all_tags, last_modified: newest_tag.updated_at.utc, etag: newest_tag) do |tag_presenters|
      tag_presenters.map(&:hash)
    end
    # explicitly setting the Cache-Control response header to public and max-age, to make the response cachable by proxy caches
    expires_in caching_time, public: true
  end

  # Create a new tag.
  def create
    # # validate the entity based on the incoming params hash
    # entity_hash = entity_hash_class.new(params_for_entity)
    # render(json: entity_hash.errors, status: :unprocessable_entity) and return unless entity_hash.valid?
    # # update an existing entity
    # if @entity = entity_class.find_by_key(key_for_entity(id_from_params))
    #   if @entity.update_collection(remove_root_element_from_json_string(entity_class.name.downcase, request.body.read), params[:version])
    #     Rails.logger.debug "Updated #{entity_class} is #{@entity.inspect}"
    #     head :no_content
    #   else
    #     Rails.logger.error "cannot update because there were errors saving #{@entity.attributes.inspect} ... #{@entity.errors.to_hash}"
    #     render(json: @entity.errors, status: :unprocessable_entity) and return
    #   end
    # else # create a new entity
    #   @entity = entity_class.init_from_params(remove_root_element_from_json_string(entity_class.name.downcase, request.body.read), params[:version], key_for_entity(id_from_params))
    #   if @entity.save
    #     render text: '{"success": true}', status: :created, location: entity_path(params[:version], @entity.data_id)
    #   else
    #     Rails.logger.error "cannot create because there were errors saving #{@entity.attributes.inspect} ... #{@entity.errors.to_hash}"
    #     render(json: @entity.errors, status: :unprocessable_entity) and return
    #   end
    # end
  end

  # Update an existing tag.
  def update
    # TODO
  end

  # Delete an tag
  def destroy
    # TODO
  end

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
