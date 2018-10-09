class ApplicationController < ActionController::Base
  if Rails.env.production?
    http_basic_authenticate_with(
      name: ENV.fetch('HTTP_BASIC_AUTH_NAME'),
      password: ENV.fetch('HTTP_BASIC_AUTH_PASSWORD')
    )
  end
end
