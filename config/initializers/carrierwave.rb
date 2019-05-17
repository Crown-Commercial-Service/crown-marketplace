if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage    = :aws
    config.aws_bucket = ENV['CCS_APP_API_DATA_BUCKET']
    config.aws_acl = 'public-read'
    config.aws_attributes = { cache_control: 'max-age=604800' }
  end
end
