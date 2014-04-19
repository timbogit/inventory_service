class RemoteCity < RemoteModel
  class << self
    def find_nearby_city_id(id, within = 15)
      with_possible_cache(cache_key_for('find_nearby_city_id', id, within)) do
        JSON.parse(Typhoeus.get("#{host}/api/v#{api_version}/#{resources}/#{id}/nearby?within=#{within}").body).map do |hsh|
          Hashie::Mash.new hsh
        end
      end
    end

    def find_by_city_ids(ids)
      find_by_ids(ids, true)
    end
  end
end
