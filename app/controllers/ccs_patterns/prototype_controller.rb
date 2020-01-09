module CcsPatterns
  class PrototypeController < FrameworkController
    skip_before_action :authenticate_user!
    before_action :set_page_detail
    before_action :set_page_model

    def index; end

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

    # rubocop:disable Metrics/MethodLength
    def page_definitions
      @page_definitions ||= {
        default: {
          back_url: ccs_patterns_path,
          back_label: 'Return to prototype index',
          back_text: 'View prototypes'
        },
        index: {
          page_title: 'Prototype List',
          caption1: 'Prototype Skeleton',
          caption2: 'Home',
          sub_title: 'View the prepared prototype views',
          secondary_url: ccs_patterns_prototypes_path,
        },
        results: {
          back_url: ccs_patterns_prototypes_path,
          page_title: 'Results',
          caption1: 'Procurement name',
          continuation_text: 'Continue',
          return_url: ccs_patterns_prototypes_path,
          return_text: 'Return to procurement dashboard',
          secondary_text: 'Change requirements'
        },
        pricing: {
          back_url: ccs_patterns_prototypes_results_path,
          back_text: 'Return to Results',
          back_label: 'Return to Results',
          page_title: 'Direct award pricing',
          caption1: 'Procurement name',
          continuation_text: 'Continue to direct award',
          return_url: ccs_patterns_prototypes_path,
          return_text: 'Return to procurement dashboard',
          secondary_text: 'Return to results'
        },
        what_next: {
          back_url: ccs_patterns_prototypes_pricing_path,
          back_text: 'Return to Pricing',
          back_label: 'Return to Pricing',
          page_title: 'What happens next',
          caption1: 'Procurement name',
          continuation_text: 'Continue to direct award',
          return_url: ccs_patterns_prototypes_results_path,
          return_text: 'Return to Results',
          secondary_text: 'Return to results'
        },
        closing_direct_award_offer: {
          back_url: ccs_patterns_prototypes_pricing_path,
          back_text: 'Back',
          back_label: 'Back',
          continuation_text: 'Close this procurement',
          secondary_text: 'Cancel'
        },
        procurement_closed: {
          back_url: ccs_patterns_prototypes_pricing_path,
          back_text: 'Back',
          back_label: 'Back',
          secondary_text: 'Return to procurement dashboard'
        },
        contract_details: {
          back_url: ccs_patterns_prototypes_path,
          back_text: 'Back',
          page_title: 'Contract Details',
          caption1: 'Total facilities management',
          continuation_text: 'Continue',
          return_url: ccs_patterns_prototypes_path,
          return_text: 'Return to procurement dashboard',
          secondary_text: 'Return to results'
        },
        invoicing_contact_details: {
          back_url: ccs_patterns_prototypes_pricing_path,
          back_text: 'Back',
          back_label: 'Back',
          page_title: 'Invoicing contact details',
          caption1: 'Total facilities management',
          continuation_text: 'Continue',
          return_url: ccs_patterns_prototypes_results_path,
          return_text: 'Return to contract details',
          secondary_text: 'Return to contract details'
        },
        new_authorised_representative_details: {
          back_url: ccs_patterns_prototypes_pricing_path,
          back_text: 'Back',
          back_label: 'Back',
          page_title: 'New authorised representative details',
          caption1: 'Total facilities management',
          continuation_text: 'Save and return',
          return_url: ccs_patterns_prototypes_results_path,
          return_text: 'Return to contract details',
          secondary_text: 'Return to contract details'
        },
        new_invoicing_contact_details: {
          back_url: ccs_patterns_prototypes_pricing_path,
          back_text: 'Back',
          back_label: 'Back',
          page_title: 'New invoicing contact details',
          caption1: 'Total facilities management',
          continuation_text: 'Save and return',
          return_url: ccs_patterns_prototypes_results_path,
          return_text: 'Return to contract details',
          secondary_text: 'Return to contract details'
        },
        invoicing_contact_details_edit_address: {
          back_url: ccs_patterns_prototypes_new_invoicing_contact_details_path,
          back_text: 'Back',
          back_label: 'Back',
          page_title: 'Add address',
          caption1: 'New invoicing contact details',
          continuation_text: 'Continue',
          return_url: ccs_patterns_prototypes_new_invoicing_contact_details_path,
          return_text: 'Return to new invoicing contact details',
        },
        did_you_know: {
          back_url: ccs_patterns_prototypes_what_next_path,
          back_text: 'Back',
          back_label: 'Back',
          page_title: 'Important information',
          caption1: 'Total facilities management',
          continuation_text: 'Continue',
          return_url: ccs_patterns_prototypes_path,
          return_text: 'Return to procurement dashboard',
          secondary_text: 'Return to results'
        },
        notices: {
          back_url: ccs_patterns_prototypes_path,
          back_text: 'Back',
          back_label: 'Back',
          page_title: 'Notices contact details',
          caption1: 'Total facilities management',
          continuation_text: 'Save and return',
          return_text: 'Return to contract details',
          return_url: ccs_patterns_prototypes_path,
        },
        new_notices_contact_details: {
          back_url: ccs_patterns_prototypes_pricing_path,
          back_text: 'Back',
          back_label: 'Back',
          page_title: 'New notices contact details',
          caption1: 'Total facilities management',
          continuation_text: 'Save and return',
          return_url: '#',
          return_text: 'Return to contract details'
        },
        payment_method: {
          back_url: ccs_patterns_prototypes_path,
          back_text: 'Back',
          page_title: 'Payment method',
          caption1: 'Total facilities management',
          continuation_text: 'Save and return',
          return_text: 'Return to contract details',
          return_url: ccs_patterns_prototypes_path,
        },
        contract_signed: {
          back_label: 'Back',
          back_text: 'Back',
          back_url: ccs_patterns_prototypes_path,
          secondary_text: 'Return to procurement dashboard',
          secondary_url: ccs_patterns_prototypes_path
        },
        confirmation_of_signed_contract: {
          back_url: ccs_patterns_prototypes_results_path,
          back_text: 'Back',
          back_label: 'Back',
          page_title: 'Confirmation of signed contract',
          caption1: 'Total facilities management',
          continuation_text: 'Save and continue',
          secondary_text: 'Cancel'
        },
        authorised_representative: {
          back_url: ccs_patterns_prototypes_path,
          back_text: 'Back',
          back_label: 'Return to Pricing',
          page_title: 'Authorised representative details',
          caption1: 'Total facilities management',
          continuation_text: 'Continue',
          return_url: ccs_patterns_prototypes_path,
          return_text: 'Return to contract details',
          secondary_text: 'Return to results'
        },
        add_missing_address: {
          back_label: 'Back',
          back_text: 'Back',
          back_url: ccs_patterns_prototypes_path,
          page_title: 'Add address',
          caption1: 'New authorised representative',
          continuation_text: 'Continue',
          return_text: 'Return to new authorised representative',
          return_url: ccs_patterns_prototypes_path,
        },
        new_notices_new_address: {
          back_label: 'Back',
          back_text: 'Back',
          back_url: ccs_patterns_prototypes_path,
          page_title: 'Add address',
          caption1: 'New notices contact details',
          continuation_text: 'Continue',
          return_text: 'Return to new notices contact details',
          return_url: ccs_patterns_prototypes_path,
        },
        lgps_check: {
          back_label: 'Back',
          back_text: 'Back',
          back_url: ccs_patterns_prototypes_path,
          page_title: 'Local Government Pension Scheme',
          caption1: 'Total facilities management',
          continuation_text: 'Save and continue',
          return_text: 'Return to contract details',
          return_url: ccs_patterns_prototypes_path,
        },
        contract_confirmation: {
          back_url: ccs_patterns_prototypes_path,
          back_text: 'Back',
          continuation_text: false,
          secondary_text: 'Return to procurement dashboard',
        },
      }.freeze
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength
  end
end
