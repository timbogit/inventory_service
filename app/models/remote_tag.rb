class RemoteTag
  class << self
    attr_accessor :host, :api_version, :max_concurrency

    def max_concurrency
      @max_concurrency ||= 1
    end

    def api_version
      @api_version ||= '1'
    end

    def find_by_name(name)
      raise "RemoteTag.host needs to be set" unless host
      Hashie::Mash.new(
          JSON.parse(Typhoeus.get("#{host}/api/v#{api_version}/tags/#{name}").body)
        )
    end

    def find_by_inventory_item_ids(ids)
      return [] unless ids.size > 0
      raise "RemoteTag.host needs to be set" unless host
      requests = []
      ids.each do |id|
        requests << Typhoeus::Request.new("#{host}/api/v#{api_version}/tags?item_id=#{id}", followlocation: true)
      end
      requests.each { |r| hydra.queue(r) }
      hydra.run
      requests.keep_if{ |req| req.response.success? }
      requests.map {|req| JSON.parse(req.response.body)}.flatten(1).map {|hsh| Hashie::Mash.new(hsh)}
    end

    def destroy_tags_for_inventory_item (item_id, tag_names = [])
      return false unless item_id
      return true if tag_names && tag_names.size == 0
      raise "RemoteTag.host needs to be set" unless host

      requests = []
      tag_names.each do |tag_name|
        requests << Typhoeus::Request.new("#{host}/api/v#{api_version}/tags/#{tag_name}/tagged_items/#{item_id}", method: :delete, followlocation: true)
      end
      requests.each { |r| hydra.queue(r) }
      hydra.run
      requests.keep_if{ |req| req.response.code == 204 }
      return requests.size > 0
    end

    private
    def hydra
      @hydra ||= begin
        Typhoeus::Hydra.new(max_concurrency: max_concurrency)
      end
    end
  end
end
