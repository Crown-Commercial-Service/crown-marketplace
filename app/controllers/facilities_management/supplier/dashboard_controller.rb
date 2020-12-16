class FacilitiesManagement::Supplier::DashboardController < FacilitiesManagement::Supplier::FrameworkController
  include FacilitiesManagement::ControllerLayoutHelper
  include FacilitiesManagement::Supplier::DashboardHelper

  before_action :set_supplier
  before_action :set_page_detail

  def index
    if !@supplier.nil?
      @received_offers = contracts.sent.where(supplier_id: @supplier.id).order(:offer_sent_date)
      @accepted_offers = contracts.accepted.where(supplier_id: @supplier.id).order(supplier_response_date: :desc)
      @live_contracts = contracts.signed.where(supplier_id: @supplier.id).order(contract_start_date: :desc, contract_end_date: :desc)
      @closed_contracts = contracts.where(supplier_id: @supplier.id, aasm_state: FacilitiesManagement::ProcurementSupplier::CLOSED_TO_SUPPLIER).sort_by(&:closed_date).reverse
    else
      @received_offers = []
      @accepted_offers = []
      @live_contracts = []
      @closed_contracts = []
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
