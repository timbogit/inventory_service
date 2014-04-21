class ApplicationController < ActionController::Base
  class BadParameters < StandardError; end
  class RestrictedActionError < StandardError; end

  rescue_from BadParameters, with: :json_error_bad_request

  private

    def caching_time
      5.minutes
    end

    def json_response(object)
      render json: Oj.dump(object)
    end

    def not_found_with_max_age(max_age = caching_time)
      head :not_found
      expires_in max_age, public: true
    end

    # Renders the results of a block passed in as JSON, but only if the
    # given 'staleness' critera are met. A presenter class is determined
    # based on the entity passed in, which gets passed back to the passed-in block.
    # Subclasses MAY override:
    # - presentable_class: to be able to change the standard PresenterFinder logic
    #                      for finding the presenter class
    # - presenter_for_entity: to be able to create special presenters that deviate
    #                         from the standard instantiation logic for the presenter class
    # - verified_representation: to be able to whitelist representations for the
    #                            entities represented
    #
    # entities        - the `entity`, or array of entities, for which to create the presenter
    # stale_criteria  - the argument to pass on to Rails' `stale?` helper to determine freshness
    # blk             - the block whose result is rendered as JSON;
    #                    the presenter determined from the `entity` is passed on to this block
    def render_if_stale(entities, stale_criteria = nil, &blk)
      return if !stale_criteria.nil? && !stale?(stale_criteria)

      entity_array = Array(entities)
      return not_found_with_max_age(caching_time) unless presenter_class = find_presenter(entity_array, params[:version])

      render_presenter(entities, presenter_class, &blk)
    end

    def find_presenter(entities, version)
      PresenterFinder.new(version, presentable_class(entities), verified_representation(params[:representation])).presenter_class
    end

    def verified_representation(representation)
      representation
    end

    def presentable_class(entities)
      entities.first.class
    end

    def render_presenter(entities, presenter_class, &blk)
      # Responses for 'single entity' endpoints are expected to be JSON hashes,
      # while 'collection' endpoints return JSON arrays. Therefore, we need to
      # check if the entities passed in are an array or a single entity to
      # render them correctly
      presenters = if entities.respond_to?(:map)
                     entities.map{ |e| presenter_for_entity(e, presenter_class) }
                   else
                     presenter_for_entity(entities, presenter_class)
                   end
      json_response( blk.call(presenters) )
    end

    def presenter_for_entity(entity, presenter_class)
      presenter_class.new(entity)
    end


    def json_error(message, status)
      render :json => { error: message }, :status => status
    end

    def json_error_bad_request(exception)
      json_error exception.message, :bad_request
    end

end
