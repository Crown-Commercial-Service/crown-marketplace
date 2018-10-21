class ApplicationController < ActionController::Base
  def require_login
    redirect_to :gateway unless logged_in?
  end

  def logged_in?
    session[:userinfo].present?
  end
  helper_method :logged_in?

  before_action :require_login
end
