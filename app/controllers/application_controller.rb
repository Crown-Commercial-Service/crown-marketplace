class ApplicationController<ActionController::Base
    Unauthorized = Class.new(StandardError)
  PERMISSIONS = %i[
    none
    facilities_management
    management_consultancy
    supply_teachers
    apprenticeships
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

  def gateway_url
    case session[:last_visited_framework]
    when 'supply_teachers'
      supply_teachers_gateway_url
    when 'management_consultancy'
      management_consultancy_gateway_url
    when 'facilities_management'
      facilities_management_gateway_url
    when 'apprenticeships'
      apprenticeships_gateway_url
    else
      ccs_homepage_url
    end
  end

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
      session[:requested_path] = request.fullpath
      redirect_to gateway_url
      return
    end

    raise Unauthorized unless current_login.permit?(@permission_required)
  end

  def logged_in?
    current_login.present?
  end
  helper_method :logged_in?

  def deny_access
    render template: 'shared/not_permitted', status: 403, locals: { permission_required: @permission_required }
  end

  delegate :ccs_homepage_url, to: Marketplace
  helper_method :ccs_homepage_url
end
