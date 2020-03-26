Sidekiq.configure_server do |config|
  Rails.logger = Sidekiq::Logging.logger
  config.redis = { url: "redis://#{ENV['CCS_REDIS_HOST']}:#{ENV['CCS_REDIS_PORT']}/0" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV['CCS_REDIS_HOST']}:#{ENV['CCS_REDIS_PORT']}/0" }
end
