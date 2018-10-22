class AuthController < ApplicationController
  skip_before_action :require_login

  def callback
    session[:userinfo] = request.env.dig('omniauth.auth', 'info', 'email')
    redirect_to :homepage
  end

  def logout
    session.delete :userinfo
    redirect_to Cognito.logout_path(gateway_url)
  end
end
