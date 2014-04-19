class RemoteTag < RemoteModel
  class << self

    def find_by_inventory_item_ids(ids)
      with_possible_cache(cache_key_for('find_by_inventory_item_ids', *ids)) do
        requests = []
        ids.each do |id|
          requests << Typhoeus::Request.new("#{host}/api/v#{api_version}/#{resources}?item_id=#{id}", followlocation: true)
        end
        get_concurrent_results(requests)
      end
    end

    def destroy_tags_for_inventory_item (item_id, tag_names = [])
      return false unless item_id
      return true if tag_names && tag_names.size == 0
      requests = []
      tag_names.each do |tag_name|
        requests << Typhoeus::Request.new("#{host}/api/v#{api_version}/#{resources}/#{tag_name}/tagged_items/#{item_id}", method: :delete, followlocation: true)
      end
      results = get_concurrent_results(requests)
      return results.size > 0
    end
  end
end
