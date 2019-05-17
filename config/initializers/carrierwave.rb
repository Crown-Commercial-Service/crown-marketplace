if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider:              'AWS',
      use_iam_profile:       true,
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    }
    config.fog_directory  = ENV['CCS_APP_API_DATA_BUCKET']
    config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" }
  end
end