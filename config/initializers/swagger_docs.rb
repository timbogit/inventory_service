if Rails.env.development?
  Swagger::Docs::Config.register_apis({
    "1.0" => {
      # the extension used for the API
      :api_extension_type => :json,
      # the output location where your .json files are written to
      :api_file_path => "public/api_docs/v1",
      # the URL base path to your API
      :base_path => "inventory-service-development.herokuapp.com/api/v1",
      # if you want to delete all .json files at each generation
      :clean_directory => true
    }
  })
end
