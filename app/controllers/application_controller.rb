class ApplicationController < ActionController::Base
  def require_sign_in
    redirect_to :gateway unless logged_in?
  end

  def logged_in?
    session[:userinfo].present?
  end
  helper_method :logged_in?

  before_action :require_sign_in
end
