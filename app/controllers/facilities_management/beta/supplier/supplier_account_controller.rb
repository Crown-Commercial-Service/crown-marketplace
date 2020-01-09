module FacilitiesManagement
  module Beta
    module Supplier
      class SupplierAccountController < FrameworkController
        skip_before_action :authenticate_user!
        before_action :set_page_detail
        before_action :set_page_model

        def index
          @page_data[:recieved_offers] = [{ contract_type: 'recieved', contract_name: 'School facilities London', buyer: 'Coal authority', date_offer_expiers: DateTime.new(2019, 7, 7, 8, 2, 0).in_time_zone('London'), status: 'ACTION REQUIRED' }]
          @page_data[:accepted_offers] = [{ contract_type: 'accepted', contract_name: 'Cabinet office FM service', buyer: 'Department for Digital, Media and Sport', date_offer_accepted: DateTime.new(2019, 7, 7, 8, 2, 0).in_time_zone('London') }]
          @page_data[:live_contracts] = [{ contract_type: 'live', contract_name: 'Cabinet office service3', buyer: 'Fleet Air Arm Museum 2', start_date: DateTime.new(2019, 7, 17, 0, 0, 0).in_time_zone('London'), end_date: DateTime.new(2029, 7, 6, 0, 0, 0).in_time_zone('London') }]
          @page_data[:closed_contracts] = [{ contract_type: 'closed', contract_name: 'Cabinet office FM', buyer: 'Cabinet office', date_closed: DateTime.new(2019, 7, 7, 8, 2, 0).in_time_zone('London'), status: 'Declined' },
                                           { contract_type: 'closed', contract_name: 'Cabinet office FM', buyer: 'Cabinet office', date_closed: DateTime.new(2019, 7, 7, 8, 2, 0).in_time_zone('London'), status: 'Not responded' },
                                           { contract_type: 'closed', contract_name: 'Cabinet office FM', buyer: 'Cabinet office', date_closed: DateTime.new(2019, 7, 7, 8, 2, 0).in_time_zone('London'), status: 'Not signed' },
                                           { contract_type: 'closed', contract_name: 'Cabinet office FM', buyer: 'Cabinet office 1234567890', date_closed: DateTime.new(2019, 7, 7, 8, 2, 0).in_time_zone('London'), status: 'Withdrawn' }]
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
            index: {
              page_title: 'Dashboard',
              caption1: 'john.smith@procurement.com'
            }
          }.freeze
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
