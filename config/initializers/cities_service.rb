config = YAML.load(File.read("#{Rails.root}/config/cities_service.yml"))[Rails.env]

RemoteCity.host = config['port'] ? "#{config['host']}:#{config['port']}" : "#{config['host']}"
RemoteCity.api_version = "#{config['api_version'] || '1'}"
RemoteCity.max_concurrency = config['max_concurrency'] || 1
