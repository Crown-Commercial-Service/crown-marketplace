module FacilitiesManagement
  module Beta
    module Supplier
      class SupplierAccountController < FacilitiesManagement::Beta::Supplier::FrameworkController
        before_action :set_supplier
        before_action :set_page_detail
        before_action :set_page_model

        def index
          @received_offers = ProcurementSupplier.unscoped.sent.where(supplier_id: @supplier.id).order(:offer_sent_date)
          @accepted_offers = ProcurementSupplier.unscoped.accepted.where(supplier_id: @supplier.id).order(supplier_response_date: :desc)
          @live_contracts = ProcurementSupplier.unscoped.signed.where(supplier_id: @supplier.id).order(contract_start_date: :desc, contract_end_date: :desc)
          @closed_contracts = ProcurementSupplier.unscoped.where(supplier_id: @supplier.id).order(contract_closed_date: :desc).select { |closed_contract| ProcurementSupplier::CLOSED_TO_SUPPLIER.include? closed_contract.aasm_state }
        end

        private

        def set_supplier
          @supplier = CCS::FM::Supplier.find_by('data @> ?', { contact_email: current_user.email }.to_json)
        end

        def set_page_model
          @page_data[:model_object] = FacilitiesManagement::Supplier::SupplierAccount.new
        end

        # rubocop:disable Metrics/AbcSize
        def set_page_detail
          @page_data = {}
          @page_description = LayoutHelper::PageDescription.new(
            LayoutHelper::HeadingDetail.new(page_details(action_name)[:page_title],
                                            page_details(action_name)[:caption1],
                                            page_details(action_name)[:caption2],
                                            page_details(action_name)[:sub_title],
                                            page_details(action_name)[:caption3]),
            LayoutHelper::BackButtonDetail.new(page_details(action_name)[:back_url],
                                               page_details(action_name)[:back_label],
                                               page_details(action_name)[:back_text]),
            LayoutHelper::NavigationDetail.new(page_details(action_name)[:continuation_text],
                                               page_details(action_name)[:return_url],
                                               page_details(action_name)[:return_text],
                                               page_details(action_name)[:secondary_url],
                                               page_details(action_name)[:secondary_text])
          )
        end

        def page_details(action)
          @page_details ||= page_definitions[:default].merge(page_definitions[action.to_sym])
        end

        def page_definitions
          @page_definitions ||= {
            default: {
              back_url: ccs_patterns_path,
              back_label: 'Return to prototype index',
              back_text: 'View prototypes'
            },
            index: {
              page_title: 'Dashboard',
              caption1: current_user.email
            }
          }.freeze
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
