class RemoteModel
  class << self
    attr_accessor :host, :api_version, :max_concurrency, :cache

    def max_concurrency
      @max_concurrency ||= 1
    end

    def api_version
      @api_version ||= '1'
    end

    def host
      raise "#{self.name}.host needs to be set" unless @host
      @host
    end

    def resource
      @resource ||= self.name.underscore.split('_').last
    end

    def resources
      resource.pluralize
    end

    def find_by_name(name)
      with_possible_cache(cache_key_for('find_by_name', name)) do
        Hashie::Mash.new(
          JSON.parse(Typhoeus.get("#{host}/api/v#{api_version}/#{resources}/#{name}").body)
        )
      end
    end

    def find_by_id(id)
      find_by_name(id)
    end

    def find_by_ids(ids, concurrent = false)
      return [] unless ids.size > 0
      with_possible_cache(cache_key_for('find_by_ids', *ids)) do
        if !concurrent
          ids.map{ |id| find_by_id(id) }
        else
          requests = []
          ids.each do |id|
            requests << Typhoeus::Request.new("#{host}/api/v#{api_version}/#{resources}/#{id}", followlocation: true)
          end
          get_concurrent_results(requests)
        end
      end
    end

    def destroy_by_name(name)
      Typhoeus::Request.delete("#{host}/api/v#{api_version}/#{resources}/#{name}", followlocation: true)
    end

    def destroy_by_id(id)
      destroy_by_name(id)
    end

    def destroy_by_ids(ids, concurrent = false)
      return [] unless ids.size > 0
      if !concurrent
        ids.map{ |id| destroy_by_id(id) }
      else
        requests = []
        ids.each do |id|
          requests << Typhoeus::Request.new("#{host}/api/v#{api_version}/#{resources}/#{id}", method: :delete, followlocation: true)
        end
        get_concurrent_results(requests)
      end
    end

    def get_concurrent_results(requests)
      return [] unless requests.size > 0
      requests.each { |r| hydra.queue(r) }
      hydra.run
      requests.keep_if{ |req| req.response.code >= 200 && req.response.code < 300 }
      requests.map {|req| req.response.body.blank? ? [] : JSON.parse(req.response.body)}.flatten(1).map {|hsh| Hashie::Mash.new(hsh)}
    end

    private

    def with_possible_cache(cache_key)
      if cache
        cache.fetch(cache_key) do
          yield
        end
      else
        yield
      end
    end

    def cache_key_for(*parts)
      ([resource, host, api_version] + parts).join('-')
    end

    def hydra
      @hydra ||= begin
        Typhoeus::Hydra.new(max_concurrency: max_concurrency)
      end
    end
  end
end
