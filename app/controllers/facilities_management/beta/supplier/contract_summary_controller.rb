module FacilitiesManagement
  module Beta
    module Supplier
      class ContractSummaryController < FrameworkController
        skip_before_action :authenticate_user!
        before_action :set_page_detail
        before_action :set_page_model
        
        def received_contract_offer
          @page_data[:procurement_data] = { contract_type: 'recieved', contract_name: 'School facilities London', buyer: 'Cabinet office', date_offer_expires: DateTime.new(2019, 7, 7, 8, 2, 0).in_time_zone('London'), contract_number: 'RM330-DA2234-2019', contract_value: '£752,026', framework: 'RM3830', sub_lot: 'sub-lot 1a', initial_call_off_period_start: DateTime.new(2019, 7, 7, 8, 2, 0).in_time_zone('London'), initial_call_off_period_end: DateTime.new(2026, 7, 7, 8, 2, 0).in_time_zone('London'), 
            mobilisation_period_start: DateTime.new(2019, 10, 3, 8, 2, 0).in_time_zone('London'), mobilisation_period_end: DateTime.new(2019, 10, 31, 8, 2, 0).in_time_zone('London'),
            optional_call_off_period_start_1: DateTime.new(2026, 10, 3, 8, 2, 0).in_time_zone('London'), optional_call_off_end_1: DateTime.new(2027, 10, 31, 8, 2, 0).in_time_zone('London'),
            optional_call_off_period_start_2: DateTime.new(2027, 10, 3, 8, 2, 0).in_time_zone('London'), optional_call_off_end_2: DateTime.new(2028, 10, 31, 8, 2, 0).in_time_zone('London'),
            buildings_and_services: [{building: 'Barton court store', services: []}, {building: 'CCS London office 5th floor', services: ['High voltage (HV) and switchgear maintenance', 'Locksmith services', 'Helpdesk services']}, {building: 'Phoenix house', services: []}, {building: 'Vale court', services: []}, {building: 'W Cabinet office 3rd floor', services: []}]
          }
          @page_data[:buyer_details] = { title: 'Miss', full_name: 'Evelyn Smith', telephone: '0300 821 4554', email: 'evelyn@cleaningltd.co.uk', building_name: 'Cleaning London LTD', street_name: '', city: 'London', county: '', postcode: 'SW1 1ET' }
        end
        
        def accepted_contract_offer
          @page_data[:procurement_data] = { contract_type: 'recieved', contract_name: 'School facilities London', buyer: 'Cabinet office', date_offer_expires: DateTime.new(2019, 7, 7, 8, 2, 0).in_time_zone('London'), contract_number: 'RM330-DA2234-2019', contract_value: '£752,026', framework: 'RM3830', sub_lot: 'sub-lot 1a', initial_call_off_period_start: DateTime.new(2019, 7, 7, 8, 2, 0).in_time_zone('London'), initial_call_off_period_end: DateTime.new(2026, 7, 7, 8, 2, 0).in_time_zone('London'), 
            mobilisation_period_start: DateTime.new(2019, 10, 3, 8, 2, 0).in_time_zone('London'), mobilisation_period_end: DateTime.new(2019, 10, 31, 8, 2, 0).in_time_zone('London'),
            optional_call_off_period_start_1: DateTime.new(2026, 10, 3, 8, 2, 0).in_time_zone('London'), optional_call_off_end_1: DateTime.new(2027, 10, 31, 8, 2, 0).in_time_zone('London'),
            optional_call_off_period_start_2: DateTime.new(2027, 10, 3, 8, 2, 0).in_time_zone('London'), optional_call_off_end_2: DateTime.new(2028, 10, 31, 8, 2, 0).in_time_zone('London'),
            buildings_and_services: [{building: 'Barton court store', services: []}, {building: 'CCS London office 5th floor', services: ['High voltage (HV) and switchgear maintenance', 'Locksmith services', 'Helpdesk services']}, {building: 'Phoenix house', services: []}, {building: 'Vale court', services: []}, {building: 'W Cabinet office 3rd floor', services: []}]
          }
          @page_data[:buyer_details] = { title: 'Miss', full_name: 'Evelyn Smith', telephone: '0300 821 4554', email: 'evelyn@cleaningltd.co.uk', building_name: 'Cleaning London LTD', street_name: '', city: 'London', county: '', postcode: 'SW1 1ET' }
        end

        private

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
              caption1: 'Schools facilities London',
              continuation_text: false,
              secondary_text: 'Return to dashboard'
            }
          }.freeze
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
