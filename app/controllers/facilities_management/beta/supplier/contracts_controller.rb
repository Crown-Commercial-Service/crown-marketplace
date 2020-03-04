module FacilitiesManagement
  module Beta
    module Supplier
      class ContractsController < FacilitiesManagement::Beta::Supplier::FrameworkController
        before_action :set_contract
        before_action :set_procurement
        before_action :set_page_detail

        def show; end

        def edit; end

        private

        def set_contract
          @contract = ProcurementSupplier.find(params[:id])
        end

        def set_procurement
          @procurement = Procurement.find(@contract.procurement.id)
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
              back_url: facilities_management_beta_supplier_contract_path(@contract.id),
              back_label: 'Back',
              back_text: 'Back'
            },
            index: {
              page_title: 'Dashboard',
              caption1: 'john.smith@procurement.com'
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
              page_title: 'Respond to contract summary'
            }
          }.freeze
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
