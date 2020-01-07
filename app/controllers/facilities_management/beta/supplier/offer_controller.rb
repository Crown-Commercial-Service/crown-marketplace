module FacilitiesManagement
  module Beta
    module Supplier
      class OfferController < FrameworkController
        skip_before_action :authenticate_user!
        before_action :set_page_detail
        before_action :set_page_model

        def declined; end
          
        def accepted
      @page_data[:contract_name] = 'School facilities London'
      @page_data[:contract_number] = 'RM330-DA2234-2019'
        end

        def accepted; end

        def respond_to_contract_offer
          @page_data[:buyer_name] = 'Coal Authority'
          @page_data[:form_text] = 'Do you accept the contract offer from Coal Authority?'
          @page_data[:checked] = ''
          @page_data[:yes_is_used] = @page_data[:checked] == 'yes'
          @page_data[:no_is_used] = @page_data[:checked] == 'no'
          @page_data[:label_text] = { contract_accepted_yes: 'yes', contract_accepted_no: 'no', contract_not_accepted: 'When you decline a contract offer you need to give a reason. <br /> Please input your answer into the box below. The reason given will be shared with the buyer and CCS.'.html_safe }
        end

        private

        def set_page_model
          @page_data[:model_object] = FacilitiesManagement::Supplier::Offer.new
          @page_data[:contract_name] = 'School facilities London'
          @page_data[:contract_number] = 'RM330-DA2334-2019'
        end

        # rubocop:disable Metrics/AbcSize
        def set_page_detail
          @page_data = {}
          @page_description = LayoutHelper::PageDescription.new(
            LayoutHelper::HeadingDetail.new(page_details(action_name)[:page_title],
                                            page_details(action_name)[:caption1],
                                            page_details(action_name)[:caption2],
                                            page_details(action_name)[:sub_title]),
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
            accepted: {
              # TODO: add the link when path is known
              back_url: '#',
              back_text: 'Back',
              back_label: 'Back',
              secondary_text: 'Return to dashboard',
              secondary_url: facilities_management_beta_supplier_supplier_account_dashboard_path
            },
            declined: {
              # TODO: add the link when path is known
              back_url: '#',
              back_text: 'Back',
              back_label: 'Back',
              secondary_text: 'Return to dashboard',
              secondary_url: facilities_management_beta_supplier_supplier_account_dashboard_path
            },
            respond_to_contract_offer: {
              # TODO: add link when path is known
              back_url: '#',
              back_text: 'Back',
              back_label: 'Back',
              page_title: 'Respond to the contract offer',
              caption1: 'School facilities London',
              continuation_text: 'Confirm and continue',
              secondary_text: 'Cancel',
              # TODO: add the link when the page is created - contract summary page
              secondary_url: '#'
            }
          }.freeze
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
