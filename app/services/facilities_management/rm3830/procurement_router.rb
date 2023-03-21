module FacilitiesManagement::RM3830
  class ProcurementRouter
    include Rails.application.routes.url_helpers

    QUICK_SEARCH_EDIT_STEPS = %w[regions services].freeze

    STEPS = %w[contract_name estimated_annual_cost tupe contract_period procurement_buildings buildings_and_services services].freeze

    SUMMARY = %w[contract_period services buildings buildings_and_services].freeze

    def initialize(id, procurement_state, step: nil, what_happens_next: false, further_competition_chosen: false)
      @id = id
      @procurement_state = procurement_state
      @step = step
      @what_happens_next = what_happens_next
      @further_competition_chosen = further_competition_chosen
    end

    STATES_TO_VIEWS = {
      quick_search: 'quick_search',
      choose_contract_value: 'choose_contract_value',
      results: 'results',
      further_competition: 'further_competition'
    }.freeze

    def view
      if STATES_TO_VIEWS.key?(@procurement_state.to_sym)
        return 'further_competition' if @procurement_state == 'results' && @further_competition_chosen
        return 'what_happens_next' if @procurement_state == 'quick_search' && @what_happens_next

        return STATES_TO_VIEWS[@procurement_state.to_sym]
      end

      'requirements'
    end

    def route
      if @procurement_state == 'quick_search'
        return QUICK_SEARCH_EDIT_STEPS.include?(@step) ? edit_facilities_management_rm3830_procurement_path(id: @id) : facilities_management_rm3830_procurements_path
      end
      return edit_facilities_management_rm3830_procurement_path(id: @id, step: previous_step) if @step == 'services'
      return facilities_management_rm3830_procurement_building_path(Procurement.find_by(id: @id).active_procurement_buildings.first) if @step == 'building_services'

      summary_page? ? facilities_management_rm3830_procurement_procurement_detail_path(procurement_id: @id, section: @step) : facilities_management_rm3830_procurement_path(id: @id)
    end

    def back_link
      return facilities_management_rm3830_procurement_path(id: @id) if previous_step.nil?

      edit_facilities_management_rm3830_procurement_path(id: @id, step: previous_step)
    end

    private

    def summary_page?
      return false if @step.nil?

      SUMMARY.include? @step
    end

    def previous_step
      return nil if @step.nil?

      return nil unless STEPS.include? @step

      return nil if @step == STEPS.first

      STEPS[STEPS.find_index(@step) - 1]
    end
  end
end
