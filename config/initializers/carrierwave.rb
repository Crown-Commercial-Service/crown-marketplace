if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage    = :aws
    config.aws_bucket = ENV['CCS_APP_API_DATA_BUCKET']
    config.aws_acl    = 'private'

    config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365
    config.aws_attributes = -> { {
      expires: 1.week.from_now.httpdate,
      cache_control: 'max-age=#{365.days.to_i}'
    } }

    config.aws_credentials = {
      region:            'eu-west-2',
      stub_responses:    Rails.env.test? # Optional, avoid hitting S3 actual during tests
    }
  end
end