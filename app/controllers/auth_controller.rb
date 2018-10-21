class AuthController < ApplicationController
  def callback
    session[:userinfo] = request.env.dig('omniauth.auth', 'info', 'email')
    redirect_to :homepage
  end
end
