if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage    = :aws
    config.aws_bucket = ENV.fetch('CCS_APP_API_DATA_BUCKET')
    config.aws_acl = 'public-read'
  end
end
