class ApplicationController < ActionController::Base
  def require_login
    redirect_to :gateway unless logged_in?
  end

  def logged_in?
    session[:userinfo].present?
  end
  helper_method :logged_in?

  if Rails.env.production?
    http_basic_authenticate_with(
      name: ENV.fetch('HTTP_BASIC_AUTH_NAME'),
      password: ENV.fetch('HTTP_BASIC_AUTH_PASSWORD')
    )
  end
end
