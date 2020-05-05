class FacilitiesManagement::Supplier::SentController < FacilitiesManagement::Beta::Supplier::FrameworkController
  def index
    @contract = ProcurementSupplier.find(params[:contract_id])
  end
end
