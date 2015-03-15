AssetSync.configure do |config|
  config.fog_provider = 'Google'
  config.google_storage_access_key_id = ENV['GCS_ACCESS_KEY_ID']
  config.google_storage_secret_access_key = ENV['GCS_SECRET_ACCESS_KEY']

  config.fog_directory = ENV['FOG_DIRECTORY']

  config.manifest = false
end
