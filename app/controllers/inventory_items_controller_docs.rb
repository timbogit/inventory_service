class Api::V1::InventoryItemsController < ApplicationController

  swagger_controller :inventory_items, "Inventory management"

  swagger_api :index do
    summary "Fetches all inventory items"
    response :not_modified, "The content has not changed in relation to the request ETag / If-Modified-Since"
  end

  swagger_api :show do
    summary "Fetches a single inventory item"
    param :path, :id, :integer, :required, "Inventory Item Id"
    response :not_found
    response :not_modified, "The content has not changed in relation to the request ETag / If-Modified-Since"
  end

  swagger_api :create do
    summary "Creates a new inventory item"
    param :form, :inventory_item, :InventoryItem, :required, "First name"
    response :unprocessable_entity
  end

  swagger_api :update do
    summary "Updates an existing inventory item"
    param :path, :id, :integer, :required, "Inventory Item Id"
    param :form, :inventory_item, :InventoryItem, :required, "First name"
    response :unprocessable_entity
    response :not_found
  end

  swagger_api :destroy do
    summary "Deletes an existing inventory item"
    param :path, :id, :integer, :required, "Inventory Item Id"
    response :unprocessable_entity
    response :not_found
  end

  # Support for Swagger complex types:
  # https://github.com/wordnik/swagger-core/wiki/Datatypes#wiki-complex-types
  swagger_model :InventoryItem do
    description "An inventory item."
    property :address_id, :integer, :required, "ID of the location where the inventory item is sold."
    property :price, :double, :required, "Price of the inventory item."
    property :title, :string, :required, "Name of the inventory item."
  end

end
