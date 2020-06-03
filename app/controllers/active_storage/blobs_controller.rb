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
    contract = FacilitiesManagement::ProcurementSupplier.find_by(id: params[:contract_id])
    procurement = FacilitiesManagement::Procurement.find_by(id: params[:procurement_id])

    raise ActionController::RoutingError, 'not found' if contract.blank? && procurement.blank?

    authorize! :view, contract if contract.present?
    authorize! :view, procurement if procurement.present?
  end
end
