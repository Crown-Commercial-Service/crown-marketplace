class AuthController < ApplicationController
  require_permission :none

  def callback
    self.current_login = Login.from_omniauth(request.env['omniauth.auth'])
    puts (session[:requested_path])
    #puts (gateway_url)
    redirect_to session[:requested_path] || gateway_url
  end

  def sign_out
    return redirect_to gateway_url if current_login.nil?

    redirect_to current_login.logout_url(self)
    delete_current_login
  end
end
