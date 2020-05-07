class FacilitiesManagement::Supplier::DashboardController < FacilitiesManagement::Supplier::FrameworkController
  include FacilitiesManagement::ControllerLayoutHelper
  include FacilitiesManagement::Supplier::DashboardHelper

  before_action :set_supplier
  before_action :set_page_detail

  # rubocop:disable Metrics/AbcSize
  def index
    if !@supplier.nil?
      @received_offers = FacilitiesManagement::ProcurementSupplier.unscoped.sent.where(supplier_id: @supplier.id).order(:offer_sent_date)
      @accepted_offers = FacilitiesManagement::ProcurementSupplier.unscoped.accepted.where(supplier_id: @supplier.id).order(supplier_response_date: :desc)
      @live_contracts = FacilitiesManagement::ProcurementSupplier.unscoped.signed.where(supplier_id: @supplier.id).order(contract_start_date: :desc, contract_end_date: :desc)
      @closed_contracts = FacilitiesManagement::ProcurementSupplier.unscoped.where(supplier_id: @supplier.id).order(contract_closed_date: :desc).select { |closed_contract| FacilitiesManagement::ProcurementSupplier::CLOSED_TO_SUPPLIER.include? closed_contract.aasm_state }
    else
      @received_offers = []
      @accepted_offers = []
      @live_contracts = []
      @closed_contracts = []
    end
  end
  # rubocop:enable Metrics/AbcSize

  private

  def set_supplier
    @supplier = CCS::FM::Supplier.find_by('data @> ?', { contact_email: current_user.email }.to_json)
  end
end
