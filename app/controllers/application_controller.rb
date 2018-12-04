class ApplicationController < ActionController::Base
  Unauthorized = Class.new(StandardError)

  PERMISSIONS = %i[
    none
    logged_in
    facilities_management
    management_consultancy
    supply_teachers
  ].freeze

  def self.require_permission(label, **kwargs)
    raise "Invalid permission #{label.inspect}" unless PERMISSIONS.include?(label)

    prepend_before_action(**kwargs) do
      # We need to prepend so that it is set before verify_permission;
      # this means that subsequent, overriding calls will be inserted above,
      # so we use ||= to make the first value stick.
      @permission_required ||= label
    end
  end

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

  def verify_permission
    raise 'please specify framework permission required' unless @permission_required
    return if @permission_required == :none

    unless logged_in?
      redirect_to :gateway
      return
    end

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
