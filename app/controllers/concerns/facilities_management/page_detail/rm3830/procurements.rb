module FacilitiesManagement::PageDetail::RM3830::Procurements
  include FacilitiesManagement::PageDetail

  def page_details
    @page_details ||= page_definitions[:default].merge(page_definitions[@view_name.to_sym])
  end

  def set_results_page_definitions
    page_definitions = {
      caption1: @procurement.contract_name,
      continuation_text: 'Continue',
      return_url: facilities_management_rm3830_procurements_path,
      return_text: 'Return to procurement dashboard',
      back_text: 'Back',
      back_url: facilities_management_rm3830_procurements_path,
      page_title: 'Results',
      primary_name: 'continue_from_results',
      secondary_name: 'change_requirements',
      secondary_text: 'Change requirements',
      secondary_url: facilities_management_rm3830_procurements_path
    }
    if @procurement.lot_number_selected_by_customer
      page_definitions[:secondary_name] = 'change_the_contract_value'
      page_definitions[:secondary_url] = facilities_management_rm3830_procurements_path
      page_definitions[:secondary_text] = 'Return to estimated contract cost'
    end
    page_definitions
  end

  def quick_search_page_title
    if params['what_happens_next'].present?
      t('facilities_management.rm3830.procurements.what_happens_next.heading')
    else
      t('facilities_management.rm3830.procurements.quick_search.quick_view_results')
    end
  end

  def set_further_competition_page_definitions
    if params[:fc_chosen] == 'true'
      {
        page_title: 'Further competition',
        secondary_text: 'Return to results',
        secondary_url: facilities_management_rm3830_procurement_path,
        continuation_text: 'Save as further competition'
      }
    else
      {
        page_title: 'Further competition',
        continuation_text: 'Make a copy of your requirements'
      }
    end
  end

  def set_quick_search_or_what_happens_next_page_definitions
    {
      back_text: 'Return to your account',
      back_url: facilities_management_rm3830_path,
      caption1: @procurement.contract_name,
      page_title: quick_search_page_title
    }
  end

  def page_definitions
    @page_definitions ||= {
      default: {
        caption1: @procurement.contract_name,
        continuation_text: 'Continue',
        return_url: facilities_management_rm3830_procurements_path,
        return_text: 'Return to procurement dashboard',
        secondary_name: 'change_requirements',
        secondary_text: 'Change requirements',
        secondary_url: facilities_management_rm3830_procurements_path,
        back_text: 'Back',
        back_url: facilities_management_rm3830_procurements_path
      },
      quick_search: set_quick_search_or_what_happens_next_page_definitions,
      what_happens_next: set_quick_search_or_what_happens_next_page_definitions,
      choose_contract_value: {
        page_title: 'Estimated contract cost',
        primary_name: 'continue_from_change_contract_value'
      },
      results: set_results_page_definitions,
      further_competition: set_further_competition_page_definitions
    }.freeze
  end
end
