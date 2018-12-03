class ApplicationController < ActionController::Base
  Unauthorized = Class.new(StandardError)

  def self.require_framework_permission(framework, **kwargs)
    append_before_action(**kwargs) do
      require_framework_permission framework
    end
  end

  before_action :require_sign_in

  rescue_from Unauthorized, with: :deny_access

  private

  def current_login
    Login.from_session(session[:login])
  end

  def current_login=(login)
    session[:login] = login.to_session
  end

  def delete_current_login
    session.delete :login
  end

  def require_sign_in
    redirect_to :gateway unless logged_in?
  end

  def require_framework_permission(framework)
    require_sign_in
    raise Unauthorized unless current_login.permit?(framework)
  end

  def logged_in?
    current_login.present?
  end
  helper_method :logged_in?

  def deny_access
    render template: 'shared/not_permitted', status: 403
  end
end
