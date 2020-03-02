module FacilitiesManagement
  module Beta
    module Procurements
      class ContractsController < FacilitiesManagement::Beta::FrameworkController
        before_action :set_procurement
        before_action :set_contract
        before_action :set_page_detail

        def show
          # TODO: This needs to be replaced with an actual call to a method with the correct date for when the contracts are generated
          @page_data[:call_off_documents_creation_date] = DateTime.now.in_time_zone('London')
        end

        def edit; end

        def update; end

        def set_procurement
          @procurement = Procurement.find(params[:procurement_id])
        end

        def set_contract
          @contract = ProcurementSupplier.find(params[:id])
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

        def set_continuation_text
          case @contract.aasm_state
          when :awaiting_contract_signature
            'Confirm if contract signed or not'
          when :accepted_not_signed, :supplier_declined, :no_supplier_response
            "View next supplier's price"
          end
        end

        def set_secondary_text
          if @contract.closed? || @contract.aasm_state == :accepted_and_signed
            'Make a copy of your requirements'
          else
            'Close this procurement'
          end
        end

        def page_definitions
          @page_definitions ||= {
            default: {
              back_text: 'Back',
              return_text: 'Return to procurement dashboard',
            },
            show: {
              back_url: facilities_management_beta_procurements_path,
              back_label: 'Back',
              back_text: 'Back',
              page_title: 'Contract summary',
              caption1: @procurement.contract_name,
              continuation_text: set_continuation_text,
              return_url: facilities_management_beta_procurements_path,
              return_text: 'Return to procurement dashboard',
              secondary_text: set_secondary_text
            },
            edit: {}
          }.freeze
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
