class AuthController < ApplicationController
  skip_before_action :require_sign_in

  def callback
    session[:auth_provider] = request.env.dig('omniauth.auth', 'provider')
    session[:userinfo] = request.env.dig('omniauth.auth', 'info', 'email')
    redirect_to :homepage
  end

  def sign_out
    session.delete :userinfo
    if session[:auth_provider] == :cognito
      redirect_to Cognito.logout_path(gateway_url)
    else
      redirect_to homepage_path
    end
  end
end
