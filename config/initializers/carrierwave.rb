if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage    = :aws
    config.aws_bucket = ENV['CCS_APP_API_DATA_BUCKET']
    config.aws_acl    = 'private'
  end
end