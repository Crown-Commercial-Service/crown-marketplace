class ApplicationController < ActionController::Base
  class UnrecognisedLiveFrameworkError < StandardError; end
  class UnrecognisedFrameworkError < StandardError; end

  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception
  before_action :authenticate_user!, :validate_service
  auto_session_timeout Devise.timeout_in

  rescue_from CanCan::AccessDenied do
    redirect_to not_permitted_path
  end

  if Rails.env.production?
    rescue_from ActionController::UnknownFormat, ActionView::MissingTemplate do
      raise ActionController::RoutingError, 'Not Found'
    end
  end

  rescue_from UnrecognisedLiveFrameworkError do
    @unrecognised_framework = params[:framework]
    params[:framework] = FacilitiesManagement::Framework.default_framework

    render 'home/unrecognised_framework', status: :bad_request
  end

  rescue_from UnrecognisedFrameworkError do
    @unrecognised_framework = params[:framework]
    params[:framework] = FacilitiesManagement::Framework.default_framework

    render 'home/unrecognised_framework', status: :bad_request
  end

  def sign_in_url
    determine_non_admin_after_sign_in
  end

  def handle_unverified_request
    sign_out
  end

  private

  def service_path_base
    @service_path_base ||= begin
      service_path_base = ['']

      service = params[:service] || 'facilities-management'
      service_name = service.split('/').first

      service_path_base << service_name.gsub('_', '-')
      service_path_base << (params[:framework] || FacilitiesManagement::Framework.default_framework) unless service_name == 'crown_marketplace'
      service_path_base << 'admin' if service.include?('admin')
      service_path_base << 'supplier' if service.include?('supplier')

      service_path_base.join('/')
    end
  end

  helper_method :service_path_base

  def determine_non_admin_after_sign_in
    session[:return_to] = request.fullpath if service_path_base.include?('facilities-management')

    "#{service_path_base}/sign-in"
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
      redirect_to sign_in_url
    end
  end

  def not_permitted_path
    "#{service_path_base}/not-permitted"
  end

  def validate_service
    redirect_to errors_404_path unless VALID_SERVICE_NAMES.include? params[:service]
  end

  VALID_SERVICE_NAMES = %w[facilities_management facilities_management/supplier facilities_management/admin facilities_management/procurements crown_marketplace].freeze

  def raise_if_unrecognised_live_framework
    raise UnrecognisedLiveFrameworkError, 'Unrecognised Live Framework' unless FacilitiesManagement::Framework.recognised_live_framework? params[:framework]
  end

  def raise_if_unrecognised_framework
    raise UnrecognisedFrameworkError, 'Unrecognised Framework' unless FacilitiesManagement::Framework.recognised_framework? params[:framework]
  end
end
