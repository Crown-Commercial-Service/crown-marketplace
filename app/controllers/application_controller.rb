class ApplicationController < ActionController::Base
  Unauthorized = Class.new(StandardError)

  def self.require_framework_permission(framework, **kwargs)
    prepend_before_action(**kwargs) do
      @permission_required = framework
    end
  end

  before_action :require_sign_in
  before_action :verify_permission

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

  def verify_permission
    raise 'please specify framework permission required' unless @permission_required
    return if @permission_required == :none

    require_sign_in
    return if @permission_required == :logged_in

    raise Unauthorized unless current_login.permit?(@permission_required)
  end

  def logged_in?
    current_login.present?
  end
  helper_method :logged_in?

  def deny_access
    render template: 'shared/not_permitted', status: 403
  end
end
