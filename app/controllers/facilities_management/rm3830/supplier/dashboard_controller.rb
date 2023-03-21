module FacilitiesManagement::RM3830
  class Supplier::DashboardController < FacilitiesManagement::Supplier::FrameworkController
    include FacilitiesManagement::PageDetail::RM3830::Supplier::Dashboard

    before_action :set_supplier
    before_action :initialize_page_description

    def index
      if @supplier.nil?
        @received_offers = []
        @accepted_offers = []
        @live_contracts = []
        @closed_contracts = []
      else
        @received_offers = contracts.sent.where(supplier_id: @supplier.id).order(:offer_sent_date)
        @accepted_offers = contracts.accepted.where(supplier_id: @supplier.id).order(supplier_response_date: :desc)
        @live_contracts = contracts.signed.where(supplier_id: @supplier.id).order(contract_start_date: :desc, contract_end_date: :desc)
        @closed_contracts = contracts.where(supplier_id: @supplier.id, aasm_state: ProcurementSupplier::CLOSED_TO_SUPPLIER).sort_by(&:closed_date).reverse
      end
    end

    private

    def set_supplier
      @supplier = current_user.supplier_detail
    end

    def contracts
      @supplier.contracts.unscoped
    end
  end
end
