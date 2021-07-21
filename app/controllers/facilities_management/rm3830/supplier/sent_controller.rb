module FacilitiesManagement::RM3830
  class Supplier::SentController < FacilitiesManagement::Supplier::FrameworkController
    def index
      @contract = ProcurementSupplier.find(params[:contract_id])
      authorize! :manage, @contract
    end
  end
end
