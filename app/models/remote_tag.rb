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
      JSON.parse(Typhoeus.get("#{host}/api/v#{api_version}/tags/#{name}").body)
    end

    def find_by_inventory_item_ids(ids)
      return [] unless ids.size > 0
      raise "RemoteTag.host needs to be set" unless host
      requests = []
      ids.each do |id|
        requests << Typhoeus::Request.new("#{host}/api/v#{api_version}/tags?item_id=#{id}")
      end
      requests.each { |r| hydra.queue(r) }
      hydra.run
      requests.keep_if{ |req| req.response.success? }
      requests.map {|req| JSON.parse(req.response.body)}.flatten(1)
    end

    private
    def hydra
      @hydra ||= begin
        Typhoeus::Config.memoize = true
        Typhoeus::Hydra.new(max_concurrency: max_concurrency)
      end
    end
  end
end
