# if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage    = :aws
    config.aws_bucket = ENV['CCS_APP_API_DATA_BUCKET']
    config.aws_acl    = 'public-read'

    # The maximum period for authenticated_urls is only 7 days.
    config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

    # Set custom options such as cache control to leverage browser caching.
    # You can use either a static Hash or a Proc.
    config.aws_attributes = -> { {
      expires: 1.year.from_now.httpdate,
      cache_control: "max-age=#{365.days.to_i}"
    } }

    config.aws_credentials = {
      region: ENV['COGNITO_AWS_REGION'],
      access_key_id: ENV['AWS_ACCESS_KEY'],
      secret_access_key: ENV['AWS_SECRET_KEY']
    }
  end
# end

if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end