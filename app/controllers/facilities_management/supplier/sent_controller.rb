class FacilitiesManagement::Supplier::SentController < FacilitiesManagement::Supplier::FrameworkController
  def index
    @contract = FacilitiesManagement::ProcurementSupplier.find(params[:contract_id])
    authorize! :manage, @contract
  end
end
