class ActiveStorage::BlobsController < ActiveStorage::BaseController
  include Rails.application.routes.url_helpers
  before_action :authenticate_user!
  before_action :authorize_user
  before_action :validate_service, except: :show
  include ActiveStorage::SetBlob

  rescue_from CanCan::AccessDenied do
    redirect_to not_permitted_path(service: 'facilities_management')
  end

  def show
    expires_in ActiveStorage.service_urls_expire_in
    redirect_to @blob.service_url(disposition: params[:disposition])
  end

  protected

  def authorize_user
    if params[:management_report_id].present?
      authenticate_admin_view(FacilitiesManagement::Admin::ManagementReport, params[:management_report_id])
    elsif params[:admin_upload_id].present?
      authenticate_admin_view(FacilitiesManagement::Admin::Upload, params[:admin_upload_id])
    else
      authorize_contract_procurement_view
    end
  end

  def authorize_contract_procurement_view
    contract = FacilitiesManagement::ProcurementSupplier.find_by(id: params[:contract_id])
    procurement = FacilitiesManagement::Procurement.find_by(id: params[:procurement_id])

    raise ActionController::RoutingError, 'not found' if contract.blank? && procurement.blank?

    authorize! :view, contract if contract.present?
    authorize! :view, procurement if procurement.present?
  end

  def authenticate_admin_view(model, id)
    object = model.find_by(id: id)

    raise ActionController::RoutingError, 'not found' if object.blank?

    authorize! :view, object if object.present?
  end
end
