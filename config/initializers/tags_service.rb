config = YAML.load(File.read("#{Rails.root}/config/tags_service.yml"))[Rails.env]

RemoteTag.host = config['port'] ? "#{config['host']}:#{config['port']}" : "#{config['host']}"
RemoteTag.api_version = "#{config['api_version'] || '1'}"
RemoteTag.max_concurrency = config['max_concurrency'] || 1
