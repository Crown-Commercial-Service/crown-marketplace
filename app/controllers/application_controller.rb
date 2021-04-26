class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception
  before_action :authenticate_user!, :validate_service
  auto_session_timeout Devise.timeout_in

  rescue_from CanCan::AccessDenied do
    redirect_to not_permitted_path(service: request.path_parameters[:controller].split('/').first)
  end

  rescue_from ActionController::UnknownFormat do
    raise ActionController::RoutingError, 'Not Found'
  end

  def gateway_url
    determine_non_admin_gateway_url
  end

  def handle_unverified_request
    sign_out
  end

  private

  def determine_non_admin_gateway_url
    case controller_path.split('/').first
    when 'supply_teachers'
      st_gateway_path
    when 'management_consultancy'
      management_consultancy_gateway_url
    when 'facilities_management'
      session[:return_to] = request.fullpath
      facilities_management_url_for_user_type
    when 'legal_services'
      legal_services_gateway_url
    else
      facilities_management_url
    end
  end

  def facilities_management_url_for_user_type
    return facilities_management_supplier_new_user_session_url if controller_path.split('/')[1] == 'supplier' && controller_path.split('/')[2] == 'contracts'

    facilities_management_gateway_url
  end

  delegate :ccs_homepage_url, to: Marketplace
  helper_method :ccs_homepage_url

  #       <%= hidden_field_tag 'current_choices', TransientSessionInfo[session.id].to_json  %>
  # to copy the cached choices
  def set_current_choices
    TransientSessionInfo[session.id] = JSON.parse(params['current_choices']) if params['current_choices']
    TransientSessionInfo[session.id] = JSON.parse(flash['current_choices']) if flash['current_choices'] && params['current_choices'].nil?
  end

  protected

  def configure_permitted_parameters
    attributes = %i[first_name last_name email phone_number mobile_number]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    devise_parameter_sanitizer.permit(:account_update, keys: attributes)
  end

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to gateway_url
    end
  end

  def st_gateway_path
    if request.headers['REQUEST_PATH']&.include?('/supply-teachers/admin')
      supply_teachers_admin_user_session_url
    else
      supply_teachers_gateway_url
    end
  end

  def validate_service
    redirect_to errors_404_path unless VALID_SERVICE_NAMES.include? params[:service]
  end

  VALID_SERVICE_NAMES = %w[facilities_management facilities_management/supplier facilities_management/admin facilities_management/procurements].freeze
end
