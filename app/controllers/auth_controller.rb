class AuthController < ApplicationController
  require_permission :none

  def callback
    self.current_login = Login.from_omniauth(request.env['omniauth.auth'])
    redirect_to session[:requested_path] || gateway_url
  end

  def sign_out
    redirect_to current_login.logout_url(self)
    delete_current_login
  end
end
