if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage    = :aws
    config.aws_bucket = ENV['CCS_APP_API_DATA_BUCKET']
    config.aws_acl = 'public-read'

    config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365

    config.aws_attributes = {
      expires: 1.year.from_now.httpdate,
      cache_control: 'max-age=31536000'
    }
  end
end
