module FacilitiesManagement
  module Beta
    module Supplier
      class ContractsController < FacilitiesManagement::Beta::Supplier::FrameworkController
        before_action :set_contract
        before_action :set_procurement
        before_action :set_page_detail, only: %i[show edit]

        def show; end

        def edit; end

        def update
          @contract.assign_attributes(contract_params)
          if @contract.valid?(:contract_response)
            if @contract.contract_response
              @contract.accept!
            else
              @contract.update(contract_params)
              @contract.decline!
            end
            redirect_to facilities_management_beta_supplier_contract_sent_index_path(@contract.id)
          else
            set_page_detail
            render :edit
          end
        end

        private

        def contract_params
          params.require(:facilities_management_procurement_supplier).permit(
            :reason_for_declining,
            :contract_response
          )
        end

        def set_contract
          @contract = ProcurementSupplier.find(params[:id])
        end

        def set_procurement
          @procurement = Procurement.find(@contract.procurement.id)
        end

        # rubocop:disable Metrics/AbcSize
        def set_page_detail
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
          action = 'edit' if action == 'update'
          @page_details ||= page_definitions[:default].merge(page_definitions[action.to_sym])
        end

        def page_definitions
          @page_definitions ||= {
            default: {
            },
            show: {
              back_url: facilities_management_beta_supplier_supplier_account_dashboard_path,
              back_label: 'Back',
              back_text: 'Back',
              page_title: 'Contract summary',
              caption1: @procurement.contract_name,
              continuation_text: 'Respond to this offer',
              secondary_text: 'Return to dashboard',
              secondary_url: facilities_management_beta_supplier_supplier_account_dashboard_path,
              return_text: 'Return to dashboard',
              return_url: facilities_management_beta_supplier_supplier_account_dashboard_path
            },
            edit: {
              back_url: facilities_management_beta_supplier_contract_path(@contract.id),
              back_label: 'Back',
              back_text: 'Back',
              page_title: 'Respond to the contract offer',
              caption1: @procurement.contract_name,
              continuation_text: 'Confirm and continue',
              secondary_text: 'Cancel',
              secondary_url: facilities_management_beta_supplier_supplier_account_dashboard_path
            }
          }.freeze
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
