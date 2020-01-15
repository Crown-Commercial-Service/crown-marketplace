module FacilitiesManagement
  module Beta
    class DirectAwardContractController < FrameworkController
      skip_before_action :authenticate_user!
      before_action :set_page_detail
      before_action :set_page_model

      def sending_the_contract
        @page_data[:supplier] = 'Cleaning London LTD'
      end

      def review_and_generate_documents
        @page_data[:procurement_data] = { contract_name: 'School facilities London', supplier: 'Cabinet office', date_offer_expires: DateTime.new(2019, 7, 7, 8, 2, 0).in_time_zone('London'), contract_number: 'RM330-DA2234-2019', contract_value: '£752,026', framework: 'RM3830', sub_lot: 'sub-lot 1a',
                                          initial_call_off_period: 7, initial_call_off_start_date: Date.new(2019, 11, 1), initial_call_off_end_date: Date.new(2016, 10, 31),
                                          expiration_date: DateTime.new(2019, 7, 23, 14, 20, 0).in_time_zone('London'), date_contract_received: DateTime.new(2019, 11, 20, 14, 0, 0).in_time_zone('London'), date_responded_to_contract: DateTime.new(2019, 6, 23, 14, 20, 0).in_time_zone('London'), date_contract_signed: DateTime.new(2019, 6, 23, 14, 20, 0).in_time_zone('London'), date_contract_closed: DateTime.new(2019, 11, 22, 14, 37, 0).in_time_zone('London'),
                                          mobilisation_period: 4, optional_call_off_extensions_1: 1, optional_call_off_extensions_2: 1, optional_call_off_extensions_3: nil, optional_call_off_extensions_4: nil,
                                          buildings_and_services: [{ building: 'Barton court store', service_codes: [] }, { building: 'CCS London office 5th floor', service_codes: ['C.13', 'C.20', 'N.1'] }, { building: 'Phoenix house', service_codes: [] }, { building: 'Vale court', service_codes: [] }, { building: 'W Cabinet office 3rd floor', service_codes: [] }] }
      end

      private

      def set_page_model
        @page_data[:model_object] = FacilitiesManagement::DirectAwardContract.new
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
          sending_the_contract: {
            back_url: ccs_patterns_prototypes_path,
            back_text: 'Back',
            page_title: 'Sending the contract',
            caption1: 'Total facilities management',
            continuation_text: 'Confirm and send contract to supplier',
            return_url: ccs_patterns_prototypes_path,
            return_text: 'Return to procurement dashboard',
            secondary_text: 'Cancel, return to review your contract'
          },
          review_and_generate_documents: {
            back_url: ccs_patterns_prototypes_path,
            back_text: 'Back',
            page_title: 'Review and generate documents',
            caption1: 'Total facilities management',
            continuation_text: 'Confirm and send contract to supplier',
            return_url: ccs_patterns_prototypes_path,
            return_text: 'Return to procurement dashboard',
            secondary_text: 'Cancel, return to review your contract'
          }
        }.freeze
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
