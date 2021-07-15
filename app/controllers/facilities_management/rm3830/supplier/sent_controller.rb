class FacilitiesManagement::RM3830::Supplier::SentController < FacilitiesManagement::Supplier::FrameworkController
  def index
    @contract = FacilitiesManagement::RM3830::ProcurementSupplier.find(params[:contract_id])
    authorize! :manage, @contract
  end
end
