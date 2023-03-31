class ActiveStorage::Blobs::RedirectController < ActiveStorage::BaseController
  include Rails.application.routes.url_helpers
  before_action :authenticate_user!
  before_action :authorize_user
  before_action :validate_service, except: :show
  include ActiveStorage::SetBlob

  rescue_from CanCan::AccessDenied do
    redirect_to facilities_management_rm3830_not_permitted_path
  end

  def show
    expires_in ActiveStorage.service_urls_expire_in
    redirect_to @blob.url(disposition: params[:disposition]), allow_other_host: true
  end

  protected

  def authorize_user
    raise CanCan::AccessDenied unless params[:key] && params[:value] && KEY_TO_MODEL.key?(params[:key].to_sym)

    object = KEY_TO_MODEL[params[:key].to_sym].find_by(id: params[:value])

    raise ActionController::RoutingError, 'not found' if object.blank?

    authorize! :read, object if object.present?
  end

  KEY_TO_MODEL = {
    rm3830_management_report_id: FacilitiesManagement::RM3830::Admin::ManagementReport,
    rm6232_management_report_id: FacilitiesManagement::RM6232::Admin::ManagementReport,
    rm3830_admin_upload_id: FacilitiesManagement::RM3830::Admin::Upload,
    rm6232_admin_upload_id: FacilitiesManagement::RM6232::Admin::Upload,
    contract_id: FacilitiesManagement::RM3830::ProcurementSupplier,
    procurement_id: FacilitiesManagement::RM3830::Procurement
  }.freeze
end
