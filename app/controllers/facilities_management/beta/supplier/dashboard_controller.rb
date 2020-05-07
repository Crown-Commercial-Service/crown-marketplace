module FacilitiesManagement
  module Beta
    module Supplier
      class DashboardController < FacilitiesManagement::Beta::Supplier::FrameworkController
        include FacilitiesManagement::ControllerLayoutHelper
        include FacilitiesManagement::Beta::Supplier::DashboardHelper

        before_action :set_supplier
        before_action :set_page_detail

        def index
          @received_offers = ProcurementSupplier.unscoped.sent.where(supplier_id: @supplier.id).order(:offer_sent_date)
          @accepted_offers = ProcurementSupplier.unscoped.accepted.where(supplier_id: @supplier.id).order(supplier_response_date: :desc)
          @live_contracts = ProcurementSupplier.unscoped.signed.where(supplier_id: @supplier.id).order(contract_start_date: :desc, contract_end_date: :desc)
          @closed_contracts = ProcurementSupplier.unscoped.where(supplier_id: @supplier.id).order(contract_closed_date: :desc).select { |closed_contract| ProcurementSupplier::CLOSED_TO_SUPPLIER.include? closed_contract.aasm_state }
        rescue StandardError
          @received_offers = []
          @accepted_offers = []
          @live_contracts = []
          @closed_contracts = []
        end

        private

        def set_supplier
          @supplier = CCS::FM::Supplier.find_by('data @> ?', { contact_email: current_user.email }.to_json)
        end
      end
    end
  end
end
