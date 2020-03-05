module FacilitiesManagement
  module Beta
    module Procurements
      class ContractsController < FacilitiesManagement::Beta::FrameworkController
        before_action :set_procurement
        before_action :set_contract
        before_action :set_page_detail, only: %i[show edit]

        def show; end

        def edit; end

        def update
          close_procurement && return if params['close_procurement'].present?
        end

        private

        def set_procurement
          @procurement = Procurement.find(params[:procurement_id])
        end

        def set_contract
          @contract = ProcurementSupplier.find(params[:id])
        end

        def close_procurement
          @contract.assign_attributes(contract_params)
          if @contract.valid?(:reason_for_closing)
            @contract.save
            @procurement.set_state_to_closed!
            redirect_to facilities_management_beta_procurement_contract_closed_index_path(@procurement.id, contract_id: @contract.id)
          else
            params[:name] = 'withdraw'
            set_page_detail
            render :edit
          end
        end

        def contract_params
          params.require(:facilities_management_procurement_supplier)
                .permit(
                  :reason_for_closing,
                )
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
        # rubocop:enable Metrics/AbcSize

        def page_details(action)
          action = 'edit' if action == 'update'
          @page_details ||= page_definitions[:default].merge(page_definitions[action.to_sym])
        end

        def set_continuation_text
          case @contract.aasm_state
          when 'accepted'
            'Confirm if contract signed or not'
          when 'not_signed', 'declined', 'expired'
            "View next supplier's price"
          end
        end

        def set_secondary_text
          if @contract.closed? || @contract.aasm_state == 'signed'
            'Make a copy of your requirements'
          else
            'Close this procurement'
          end
        end

        def page_definitions
          @page_definitions ||= {
            default: {
              back_label: 'Back',
              back_text: 'Back',
              back_url: facilities_management_beta_procurements_path,
              return_text: 'Return to procurement dashboard',
              return_url: facilities_management_beta_procurements_path,
            },
            show: {
              page_title: 'Contract summary',
              caption1: @procurement.contract_name,
              continuation_text: set_continuation_text,
              return_text: 'Return to procurement dashboard',
              secondary_text: set_secondary_text
            },
            edit: {
              back_url: facilities_management_beta_procurement_contract_path(@procurement),
              continuation_text: 'Close this procurement',
              secondary_text: 'Cancel',
            },
          }.freeze
        end
      end
    end
  end
end
