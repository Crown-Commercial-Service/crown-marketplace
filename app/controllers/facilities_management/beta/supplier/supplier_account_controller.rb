module FacilitiesManagement
  module Beta
    module Supplier
      class SupplierAccountController < FrameworkController
        skip_before_action :authenticate_user!
        before_action :set_page_detail
        before_action :set_page_model

        def index
          @page_data[:received_offers] = [{ contract_type: 'received', contract_name: 'School facilities London', buyer: 'Coal authority', date_offer_expiers: DateTime.new(2019, 7, 7, 8, 2, 0).in_time_zone('London'), status: 'ACTION REQUIRED' }]
          @page_data[:accepted_offers] = [{ contract_type: 'accepted', contract_name: 'Cabinet office FM service', buyer: 'Department for Digital, Media and Sport', date_offer_accepted: DateTime.new(2019, 7, 7, 8, 2, 0).in_time_zone('London') }]
          @page_data[:live_contracts] = [{ contract_type: 'live', contract_name: 'Cabinet office service3', buyer: 'Fleet Air Arm Museum 2', start_date: DateTime.new(2019, 7, 17, 0, 0, 0).in_time_zone('London'), end_date: DateTime.new(2029, 7, 6, 0, 0, 0).in_time_zone('London') }]
          @page_data[:closed_contracts] = [{ contract_type: 'closed', contract_name: 'Cabinet office FM', buyer: 'Cabinet office', date_closed: DateTime.new(2019, 7, 7, 8, 2, 0).in_time_zone('London'), status: 'Declined', path: facilities_management_beta_supplier_contract_summary_declined_offer_url},
                                           { contract_type: 'closed', contract_name: 'Cabinet office FM', buyer: 'Cabinet office', date_closed: DateTime.new(2019, 7, 7, 8, 2, 0).in_time_zone('London'), status: 'Not responded', path: facilities_management_beta_supplier_contract_summary_not_responded_url},
                                           { contract_type: 'closed', contract_name: 'Cabinet office FM', buyer: 'Cabinet office', date_closed: DateTime.new(2019, 7, 7, 8, 2, 0).in_time_zone('London'), status: 'Not signed', path: facilities_management_beta_supplier_contract_summary_not_signed_url },
                                           { contract_type: 'closed', contract_name: 'Cabinet office FM', buyer: 'Cabinet office 1234567890', date_closed: DateTime.new(2019, 7, 7, 8, 2, 0).in_time_zone('London'), status: 'Withdrawn', path: facilities_management_beta_supplier_contract_summary_contract_withdrawn_url }]
        end

        def show
          @page_data[:procurement_data] = { contract_name: 'School facilities London', buyer: 'Cabinet office', date_offer_expires: DateTime.new(2019, 7, 7, 8, 2, 0).in_time_zone('London'), contract_number: 'RM330-DA2234-2019', contract_value: '£752,026', framework: 'RM3830', sub_lot: 'sub-lot 1a',
                                            initial_call_off_period: 7, initial_call_off_start_date: Date.new(2019, 11, 1), initial_call_off_end_date: Date.new(2016, 10, 31),
                                            expiration_date: DateTime.new(2019, 7, 23, 14, 20, 0).in_time_zone('London'), date_contract_received: DateTime.new(2019, 11, 20, 14, 0, 0).in_time_zone('London'), date_responded_to_contract: DateTime.new(2019, 6, 23, 14, 20, 0).in_time_zone('London'), date_contract_signed: DateTime.new(2019, 6, 23, 14, 20, 0).in_time_zone('London'), date_contract_closed: DateTime.new(2019, 11, 22, 14, 37, 0).in_time_zone('London'),
                                            mobilisation_period: 4, optional_call_off_extensions_1: 1, optional_call_off_extensions_2: 1, optional_call_off_extensions_3: nil, optional_call_off_extensions_4: nil,
                                            buildings_and_services: [{ building: 'Barton court store', services: [] }, { building: 'CCS London office 5th floor', services: ['High voltage (HV) and switchgear maintenance', 'Locksmith services', 'Helpdesk services'] }, { building: 'Phoenix house', services: [] }, { building: 'Vale court', services: [] }, { building: 'W Cabinet office 3rd floor', services: [] }] }
          @page_data[:buyer_details] = { title: 'Miss', full_name: 'Evelyn Smith', telephone: '0300 821 4554', email: 'evelyn@cleaningltd.co.uk', building_name: 'Cleaning London LTD', street_name: '', city: 'London', county: '', postcode: 'SW1 1ET' }
          @page_data[:call_off_documents_creation_date] = DateTime.new(2019, 5, 14, 10, 47, 0).in_time_zone('London')
          # TODO: When db intigrated this section can be refactored or removed
          @page_data[:procurement_data][:status] = find_status(request.path_info)
          @page_data[:procurement_data][:reason] = 'conflict of interest.' if @page_data[:procurement_data][:status] == 'declined'
          @page_data[:procurement_data][:reason] = 'not enough resources to supply 1 or more services.' if @page_data[:procurement_data][:status] == 'withdrawn'
        end

        private

        # rubocop:disable Metrics/CyclomaticComplexity
        # rubocop:disable Metrics/PerceivedComplexity
        def find_status(path)
          return 'received' if path.include?('received-contract-offer')
          return 'accepted' if path.include?('accepted-contract-offer')
          return 'live' if path.include?('live-contract')
          return 'declined' if path.include?('declined-offer')
          return 'not responded' if path.include?('not-responded')
          return 'not signed' if path.include?('not-signed')
          return 'withdrawn' if path.include?('contract-withdrawn')
        end
        # rubocop:enable Metrics/PerceivedComplexity
        # rubocop:enable Metrics/CyclomaticComplexity

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
            index: {
              page_title: 'Dashboard',
              caption1: 'john.smith@procurement.com'
            },
            show: {
              back_url: facilities_management_beta_supplier_supplier_account_dashboard_path,
              back_label: 'Back',
              back_text: 'Back',
              page_title: 'Contract summary',
              caption1: 'Cabinet office service3',
              continuation_text: 'Respond to this offer',
              secondary_text: 'Return to dashboard',
              secondary_url: facilities_management_beta_supplier_supplier_account_dashboard_path,
              return_text: 'Return to dashboard',
              return_url: facilities_management_beta_supplier_supplier_account_dashboard_path
            }
          }.freeze
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
