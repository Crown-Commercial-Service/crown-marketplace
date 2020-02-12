module CcsPatterns
  class PrototypeController < FrameworkController
    skip_before_action :authenticate_user!
    before_action :set_page_detail
    before_action :set_page_model

    def index; end

    def no_response
      @page_data[:procurement_data] = { contract_name: 'School facilities London', supplier: 'Cabinet office', date_offer_expires: DateTime.new(2019, 7, 7, 8, 2, 0).in_time_zone('London'), contract_number: 'RM330-DA2234-2019', contract_value: '£752,026', framework: 'RM3830', sub_lot: 'sub-lot 1a',
        initial_call_off_period: 7, initial_call_off_start_date: Date.new(2019, 11, 1), initial_call_off_end_date: Date.new(2016, 10, 31),
        contract_sent_date: DateTime.new(2019, 6, 23, 14, 20, 0).in_time_zone('London'), expiration_date: DateTime.new(2019, 7, 23, 14, 20, 0).in_time_zone('London'), date_contract_received: DateTime.new(2019, 11, 20, 14, 0, 0).in_time_zone('London'), date_responded_to_contract: DateTime.new(2019, 6, 23, 14, 20, 0).in_time_zone('London'), date_contract_signed: DateTime.new(2019, 6, 23, 14, 20, 0).in_time_zone('London'), date_contract_closed: DateTime.new(2019, 11, 22, 14, 37, 0).in_time_zone('London'),
        mobilisation_period: 4, optional_call_off_extensions_1: 1, optional_call_off_extensions_2: 1, optional_call_off_extensions_3: nil, optional_call_off_extensions_4: nil,
        buildings_and_services: [{ building: 'Barton court store', service_codes: [] }, { building: 'CCS London office 5th floor', service_codes: ['C.13', 'C.20', 'N.1'] }, { building: 'Phoenix house', service_codes: [] }, { building: 'Vale court', service_codes: [] }, { building: 'W Cabinet office 3rd floor', service_codes: [] }], call_off_documents_creation_date: DateTime.new(2019, 5, 14, 10, 47, 0).in_time_zone('London') }
        # TODO: When db intigrated this section can be refactored or removed
    end

    def results
      @page_data[:selected_sublot] = 'Lot 1a'
      @page_data[:estimated_cost] = '1450000'
      @page_data[:no_suppliers] = 11
      @page_data[:supplier_collection] = ['Alpha John Smith Co Ltd', 'Example Corporation LTD', 'Another example Corp Ltd', 'HG Cleaning', 'Marco LTD', 'Gig Beta Company', 'Mega Beta Ltd', 'Jacob Beta Company', 'Kile Beta', 'Oscar Wild Corp.', 'X-ray Cleaning Ltd']
      @page_data[:supplier_prices] = [1280500, 1300000, 1300000, 1300000, 1300000, 1300000, 1300000, 1300000, 1300000, 1300000, 1300000]
      @page_data[:buildings] = ['building 1', 'building 2']
      @page_data[:services] = ['cut flowers and christmas trees', 'grounds maintenance services', 'internal planting', 'professional snow and ice clearance', 'reservoirs, ponds, river walls and water-feature maintenance', 'tree surgery', 'taxi booking service']
    end

    def contract_details
      @page_data[:further_information] = ['Payment method', 'Invoicing contact details', 'Authorised representative', 'Notices contact details', 'Security policy', 'Local government pension scheme']
    end

    def pricing
      @page_data[:sorted_supplier_list] = [{ name: 'Cleaning London LTD', price: 1280500 }, { name: 'Example Corporation LTD', price: '1300000' }, { name: 'Another example Corp Ltd', price: '1353400' },
                                           { name: 'HG Cleaning', price: '1300000' }, { name: 'Marco LTD', price: '1300000' }, { name: 'Gig Beta Company', price: '1300000' }, { name: 'Mega Beta Ltd', price: '1300000' },
                                           { name: 'Jacob Beta Company', price: '1300000' }, { name: 'Kile Beta', price: '1300000' }, { name: 'Oscar Wild Corp.', price: '1300000' }, { name: 'X-ray Cleaning Ltd', price: '1300000' }]
    end

    def what_next; end

    def did_you_know; end

    def closing_direct_award_offer
      @page_data[:contract_name] = 'Total facilities management'
      @page_data[:contract_code] = 'FM-093-2019'
    end

    def invoicing_contact_details
      @page_data[:invoicing_contact_full_name] = 'Fake Full Name'
      @page_data[:invoicing_contact_job_title] = 'Fake Job Title'
      @page_data[:invoicing_contact_address] = ['1 Fake Address', 'Fake Address Lane', 'Faketown', 'Fakedon', 'FA1 5KE'].join(', ')
    end

    def new_invoicing_contact_details; end

    def invoicing_contact_details_edit_address
      @page_data[:label_text] = { county: 'County (optional)' }
      @page_data[:postcode] = 'FA1 5KE'
    end

    def new_authorised_representative_details; end

    def authorised_representative
      @page_data[:invoicing_contact_full_name] = 'Fake Full Name'
      @page_data[:invoicing_contact_job_title] = 'Fake Job Title'
      @page_data[:invoicing_contact_address] = ['1 Fake Address', 'Fake Address Lane', 'Faketown', 'Fakedon', 'FA1 5KE'].join(', ')
    end

    def new_notices_contact_details; end

    def payment_method; end

    def procurement_closed
      @page_data[:procurement_name] = 'Total facilities management'
      @page_data[:procurement_number] = 'FM-094-2019'
    end

    def notices
      @page_data[:notices_contact_full_name] = 'Fake Full Name'
      @page_data[:notices_contact_job_title] = 'Fake Job Title'
      @page_data[:notices_contact_address] = ['1 Fake Address', 'Fake Address Lane', 'Faketown', 'Fakedon', 'FA1 5KE'].join(', ')
    end

    def confirmation_of_signed_contract
      @page_data[:form_text] = 'Please confirm if both parties have signed and exchanged the contract'
      @page_data[:label_text] = { contract_signed_yes: 'Yes', contract_signed_no: 'No', contract_not_signed: 'This contract will not be signed.<br />Please input the reason. Once you have saved and continued, you will be presented with your options on how to proceed further.'.html_safe }
      @page_data[:checked] = ''
      @page_data[:yes_is_used] = @page_data[:checked] == 'yes'
      @page_data[:no_is_used] = @page_data[:checked] == 'no'
    end

    def add_missing_address
      @page_data[:label_text] = { county: 'County (optional)' }
      @page_data[:postcode] = 'SW1 2AA'
    end

    def contract_signed
      @page_data[:start_date] = Date.new(2019, 11, 19)&.strftime '%d %B %Y'
      @page_data[:end_date] = Date.new(2026, 12, 26)&.strftime '%d %B %Y'
      @page_data[:contract_name] = 'School facilities London'
      @page_data[:contract_code] = 'FM-094-2019'
    end

    def new_notices_new_address
      @page_data[:label_text] = { county: 'County (optional)' }
      @page_data[:postcode] = 'SW1 2AA'
    end

    def lgps_check; end

    def contract_confirmation
      @page_data[:contact_name] = 'Total facilities management'
      @page_data[:contact_code] = 'FM-094-2019'
      @page_data[:supplier_name] = 'Cleaning London LTD'
    end

    private

    def set_page_model
      @page_data[:model_object] = FacilitiesManagement::NewProcurementData.new
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
          back_url: ccs_patterns_path,
          back_label: 'Return to prototype index',
          back_text: 'View prototypes',
          return_text: 'return'
        },
        index: {
          page_title: 'Prototype List',
          caption1: 'Prototype Skeleton',
          caption2: 'Home',
          sub_title: 'View the prepared prototype views',
          secondary_url: ccs_patterns_prototypes_path,
        },
        no_response: {
          page_title: 'CCT repairs services',
          back_text: 'Back',
          continuation_text: "View next supplier's price",
          caption1: 'Contract summary',
          secondary_text: 'Close this procurement',
          return_text: 'Return to procurement dashboard',
          return_link: '#'
        }
      }.freeze
    end
    # rubocop:enable Metrics/AbcSize
  end
end
