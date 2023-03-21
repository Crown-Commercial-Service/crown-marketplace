Sidekiq.configure_server do |config|
  Rails.logger = Sidekiq.logger
  config.redis = { url: "redis://#{ENV.fetch('CCS_REDIS_HOST', nil)}:#{ENV.fetch('CCS_REDIS_PORT', nil)}/0" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV.fetch('CCS_REDIS_HOST', nil)}:#{ENV.fetch('CCS_REDIS_PORT', nil)}/0" }
end
