class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do
    redirect_to not_permitted_path(permission_required: request.path_parameters[:controller].split('/').first)
  end

  def gateway_url
    case session[:last_visited_framework]
    when 'supply_teachers'
      st_gateway_path
    when 'management_consultancy'
      management_consultancy_gateway_url
    when 'facilities_management/beta'
      facilities_management_beta_gateway_url
    when 'facilities_management'
      facilities_management_gateway_url
    when 'legal_services'
      legal_services_gateway_url
    else
      supply_teachers_gateway_url
    end
  end

  def home_page_url
    case session[:last_visited_framework]
    when 'supply_teachers'
      st_home_url
    when 'management_consultancy'
      management_consultancy_url
    when 'facilities_management'
      facilities_management_url
    when 'apprenticeships'
      apprenticeships_url
    when 'legal_services'
      legal_services_url
    else
      ccs_homepage_url
    end
  end

  private

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

  def set_end_of_journey
    @end_of_journey = true
  end

  def st_gateway_path
    if request.headers['REQUEST_PATH']&.include?('/supply-teachers/admin')
      supply_teachers_admin_user_session_url
    else
      supply_teachers_gateway_url
    end
  end

  def st_home_url
    if request.headers['REQUEST_PATH']&.include?('/supply-teachers/admin')
      supply_teachers_admin_uploads_path
    else
      supply_teachers_gateway_url
    end
  end
end
