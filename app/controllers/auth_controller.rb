class AuthController < ApplicationController
  skip_before_action :require_sign_in
  require_framework_permission :none

  def callback
    self.current_login = Login.from_omniauth(request.env['omniauth.auth'])
    redirect_to :homepage
  end

  def sign_out
    redirect_to current_login.logout_path(self)
    delete_current_login
  end
end
