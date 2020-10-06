class ActiveStorage::BlobsController < ActiveStorage::BaseController
  include Rails.application.routes.url_helpers
  before_action :authenticate_user!
  before_action :authorize_user
  include ActiveStorage::SetBlob

  rescue_from CanCan::AccessDenied do
    redirect_to not_permitted_path(service: 'facilities_management')
  end

  def show
    expires_in ActiveStorage::Blob.service.url_expires_in
    redirect_to @blob.service_url(disposition: params[:disposition])
  end

  protected

  def authorize_user
    if params[:management_report_id].present?
      authorize_management_report_view
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

  def authorize_management_report_view
    management_report = FacilitiesManagement::Admin::ManagementReport.find_by(id: params[:management_report_id])

    raise ActionController::RoutingError, 'not found' if management_report.blank?

    authorize! :view, management_report if management_report.present?
  end
end
