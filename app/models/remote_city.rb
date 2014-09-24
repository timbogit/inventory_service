class RemoteCity
  class << self
    attr_accessor :host, :api_version, :max_concurrency

    def max_concurrency
      @max_concurrency ||= 1
    end

    def api_version
      @api_version ||= '1'
    end

    def find_nearby_city_id(id, within = 15)
      raise "RemoteCity.host needs to be set" unless host
      JSON.parse(Typhoeus.get("#{host}/api/v#{api_version}/cities/#{id}/nearby?within=#{within}").body).map do |hsh|
        Hashie::Mash.new hsh
      end
    end

    def find_by_city_ids(ids)
      return [] unless ids.size > 0
      raise "RemoteCity.host needs to be set" unless host
      requests = []
      ids.each do |id|
        requests << Typhoeus::Request.new("#{host}/api/v#{api_version}/cities/#{id}", followlocation: true)
      end
      requests.each { |r| hydra.queue(r) }
      hydra.run
      requests.keep_if{ |req| req.response.success? }
      requests.map {|req| JSON.parse(req.response.body)}.flatten(1).map {|hsh| Hashie::Mash.new(hsh)}
    end

    private
    def hydra
      @hydra ||= begin
        Typhoeus::Hydra.new(max_concurrency: max_concurrency)
      end
    end
  end
end
