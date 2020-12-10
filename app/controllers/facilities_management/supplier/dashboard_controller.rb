class FacilitiesManagement::Supplier::DashboardController < FacilitiesManagement::Supplier::FrameworkController
  include FacilitiesManagement::ControllerLayoutHelper
  include FacilitiesManagement::Supplier::DashboardHelper

  before_action :set_supplier
  before_action :set_page_detail

  def index
    if !@supplier.nil?
      @received_offers = FacilitiesManagement::ProcurementSupplier.unscoped.sent.where(supplier_id: @supplier.id).order(:offer_sent_date)
      @accepted_offers = FacilitiesManagement::ProcurementSupplier.unscoped.accepted.where(supplier_id: @supplier.id).order(supplier_response_date: :desc)
      @live_contracts = FacilitiesManagement::ProcurementSupplier.unscoped.signed.where(supplier_id: @supplier.id).order(contract_start_date: :desc, contract_end_date: :desc)
      @closed_contracts = FacilitiesManagement::ProcurementSupplier.unscoped.where(supplier_id: @supplier.id, aasm_state: FacilitiesManagement::ProcurementSupplier::CLOSED_TO_SUPPLIER).sort_by(&:closed_date).reverse
    else
      @received_offers = []
      @accepted_offers = []
      @live_contracts = []
      @closed_contracts = []
    end
  end

  private

  def set_supplier
    @supplier = CCS::FM::Supplier.find_by(contact_email: current_user.email)
  end
end
