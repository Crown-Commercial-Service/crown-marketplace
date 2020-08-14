if defined?(AssetSync) && ENV['APP_RUN_PRECOMPILE_ASSETS'] == 'TRUE'
  AssetSync.configure do |config|
    config.fog_provider = 'AWS'
    config.aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
    config.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    config.aws_session_token = ENV['AWS_SESSION_TOKEN'] if ENV.key?('AWS_SESSION_TOKEN')
    config.fog_directory = ENV['ASSETS_BUCKET']
  end
end
