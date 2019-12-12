module CcsPatterns
  class PrototypeController < FrameworkController
    skip_before_action :authenticate_user!
    before_action :set_page_detail

    def index; end

    def results
      @page_data[:model_object] = FacilitiesManagement::NewProcurementData.new
      @page_data[:selected_sublot] = 'Lot 1a'
      @page_data[:estimated_cost] = '1450000'
      @page_data[:no_suppliers] = 11
      @page_data[:supplier_collection] = ['Alpha John Smith Co Ltd', 'Example Corporation LTD', 'Another example Corp Ltd', 'HG Cleaning', 'Marco LTD', 'Gig Beta Company', 'Mega Beta Ltd', 'Jacob Beta Company', 'Kile Beta', 'Oscar Wild Corp.', 'X-ray Cleaning Ltd']
      @page_data[:supplier_prices] = [1280500, 1300000, 1300000, 1300000, 1300000, 1300000, 1300000, 1300000, 1300000, 1300000, 1300000]
      @page_data[:buildings] = ['building 1', 'building 2']
      @page_data[:services] = ['cut flowers and christmas trees', 'grounds maintenance services', 'internal planting', 'professional snow and ice clearance', 'reservoirs, ponds, river walls and water-feature maintenance', 'tree surgery', 'taxi booking service']
    end

    def pricing
      @page_data[:model_object] = FacilitiesManagement::NewProcurementData.new
      @page_data[:sorted_supplier_list] = [{ name: 'Cleaning London LTD', price: 1280500 }, { name: 'Example Corporation LTD', price: '1300000' }, { name: 'Another example Corp Ltd', price: '1353400' },
                                           { name: 'HG Cleaning', price: '1300000' }, { name: 'Marco LTD', price: '1300000' }, { name: 'Gig Beta Company', price: '1300000' }, { name: 'Mega Beta Ltd', price: '1300000' },
                                           { name: 'Jacob Beta Company', price: '1300000' }, { name: 'Kile Beta', price: '1300000' }, { name: 'Oscar Wild Corp.', price: '1300000' }, { name: 'X-ray Cleaning Ltd', price: '1300000' }]
    end

    def what_next
      @page_data[:model_object] = FacilitiesManagement::NewProcurementData.new
    end

    private

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
    # rubocop:enable Metrics/AbcSize

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
        }
      }.freeze
    end
  end
end
