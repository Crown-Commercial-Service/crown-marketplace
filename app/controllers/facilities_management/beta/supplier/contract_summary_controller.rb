module FacilitiesManagement
  module Beta
    module Supplier
      class ContractSummaryController < FrameworkController
        skip_before_action :authenticate_user!
        before_action :set_page_detail
        before_action :set_page_model

        def received_contract_offer; end

        def live_contract; end

        def accepted_contract_offer; end

        def not_signed_offer
          offer_timestamp = '23 June 2019, 3:20pm'
          accepted_timestamp = '23 January 2019, 2:30pm'
          received_timestamp = '22 Januart 2019, 9:21am'
          @page_data[:status_message] = { status: "The buyer has recorded this contract as 'not signed' on #{offer_timestamp}.",
                                          status2: 'The contract offer has therefore been closed.',
                                          message: "You accepted this contract offer on #{accepted_timestamp}.",
                                          message2: "This contract offer was received on #{received_timestamp}." }
        end

        def declined_offer
          offer_timestamp = '21 November 2019, 8:45pm'
          reason = 'conflict of interest'
          received_timestamp = '20 November 2019, 2:00pm'
          @page_data[:status_message] = { status: "You declined this contract offer on #{offer_timestamp}.",
                                          message: "Your reason for declining was: #{reason}",
                                          message2: "This contract offer was received on #{received_timestamp}." }
        end

        def not_responded_to_contract_offer; end

        private

        def set_page_model
          @page_data[:model_object] = nil
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
          @page_data[:procurement_data] = { contract_name: 'School facilities London', buyer: 'Cabinet office', date_offer_expires: DateTime.new(2019, 7, 7, 8, 2, 0).in_time_zone('London'), contract_number: 'RM330-DA2234-2019', contract_value: '£752,026', framework: 'RM3830', sub_lot: 'sub-lot 1a',
                                            initial_call_off_period_start: Date.new(2019, 11, 1), initial_call_off_period_end: Date.new(2016, 10, 31),
                                            date_contract_received: DateTime.new(2019, 11, 20, 14, 0, 0).in_time_zone('London'), date_contract_accepted: DateTime.new(2019, 6, 23, 14, 20, 0).in_time_zone('London'), date_contract_closed: DateTime.new(2019, 11, 22, 14, 37, 0).in_time_zone('London'),
                                            mobilisation_period_start: Date.new(2019, 10, 3), mobilisation_period_end: Date.new(2019, 10, 31),
                                            optional_call_off_period_start_1: Date.new(2026, 11, 1), optional_call_off_end_1: Date.new(2027, 10, 31),
                                            optional_call_off_period_start_2: Date.new(2027, 11, 1), optional_call_off_end_2: Date.new(2028, 10, 31),
                                            buildings_and_services: [{ building: 'Barton court store', services: [] }, { building: 'CCS London office 5th floor', services: ['High voltage (HV) and switchgear maintenance', 'Locksmith services', 'Helpdesk services'] }, { building: 'Phoenix house', services: [] }, { building: 'Vale court', services: [] }, { building: 'W Cabinet office 3rd floor', services: [] }] }
          @page_data[:buyer_details] = { title: 'Miss', full_name: 'Evelyn Smith', telephone: '0300 821 4554', email: 'evelyn@cleaningltd.co.uk', building_name: 'Cleaning London LTD', street_name: '', city: 'London', county: '', postcode: 'SW1 1ET' }
          @page_data[:call_off_documents_creation_date] = DateTime.new(2019, 5, 14, 10, 47, 0).in_time_zone('London')
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
            live_contract: {
              back_url: facilities_management_beta_supplier_supplier_account_dashboard_path,
              back_label: 'Back',
              back_text: 'Back',
              page_title: 'Contract summary',
              caption1: 'Cabinet office service3',
              secondary_text: 'Return to dashboard',
              secondary_url: facilities_management_beta_supplier_supplier_account_dashboard_path
            },
            not_responded_to_contract_offer: {
              back_url: facilities_management_beta_supplier_supplier_account_dashboard_path,
              back_label: 'Back',
              back_text: 'Back',
              page_title: 'Contract summary',
              caption1: 'Cabinet office FM services',
              secondary_text: 'Return to dashboard',
              secondary_url: facilities_management_beta_supplier_supplier_account_dashboard_path
            },
            received_contract_offer: {
              back_url: facilities_management_beta_supplier_supplier_account_dashboard_path,
              back_label: 'Back',
              back_text: 'Back',
              page_title: 'Contract summary',
              caption1: 'Schools facilities London'
            },
            accepted_contract_offer: {
              back_url: facilities_management_beta_supplier_supplier_account_dashboard_path,
              back_label: 'Back',
              back_text: 'Back',
              page_title: 'Contract summary',
              caption1: 'Cabinet office FM services',
              continuation_text: false,
              secondary_text: 'Return to dashboard'
            },
            not_signed_offer: {
              back_url: facilities_management_beta_supplier_supplier_account_dashboard_path,
              back_label: 'Back',
              back_text: 'Back',
              page_title: 'Contract summary',
              caption1: 'Schools facilities London',
              secondary_text: 'Return to dashboard',
              secondary_url: facilities_management_beta_supplier_supplier_account_dashboard_path
            },
            declined_offer: {
              back_url: facilities_management_beta_supplier_supplier_account_dashboard_path,
              back_label: 'Back',
              back_text: 'Back',
              page_title: 'Contract summary',
              caption1: 'Schools facilities London',
              secondary_text: 'Return to dashboard',
              secondary_url: facilities_management_beta_supplier_supplier_account_dashboard_path
            }
          }.freeze
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
