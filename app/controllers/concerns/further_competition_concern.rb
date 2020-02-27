module FurtherCompetitionConcern
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/AbcSize
  def build_direct_award_report(cache__calculation_values_for_spreadsheet_flag, start_date, current_user, session_data)
    user_email = current_user.email.to_s

    @report = FacilitiesManagement::SummaryReport.new(start_date, user_email, session_data, @procurement)

    if @procurement
      @selected_buildings = @procurement.active_procurement_buildings
    else
      @selected_buildings = CCS::FM::Building.buildings_for_user(user_email)
      uvals = @report.uom_values(@selected_buildings)
    end

    rates = CCS::FM::Rate.read_benchmark_rates
    @rate_card = CCS::FM::RateCard.latest

    @results = {}
    @report_results = {} if cache__calculation_values_for_spreadsheet_flag

    # get the services including help & cafm for the,contract rate card,worksheet
    @report_results_no_cafmhelp_removed = {} if cache__calculation_values_for_spreadsheet_flag

    supplier_names = @rate_card.data[:Prices].keys
    supplier_names.each do |supplier_name|
      a_supplier_calculation_results = @report_results[supplier_name] = {} if cache__calculation_values_for_spreadsheet_flag
      @report.calculate_services_for_buildings @selected_buildings, uvals, rates, @rate_card, supplier_name, a_supplier_calculation_results, true, :fc
      @results[supplier_name] = @report.direct_award_value

      a_supplier_calculation_results_no_cafmhelp_removed = @report_results_no_cafmhelp_removed[supplier_name] = {} if cache__calculation_values_for_spreadsheet_flag
      @report.calculate_services_for_buildings @selected_buildings, uvals, rates, @rate_card, supplier_name, a_supplier_calculation_results_no_cafmhelp_removed, false, :fc
    end

    sorted_list = @results.sort_by { |_k, v| v }
    @supplier_name = sorted_list.first[0]
  end
  # rubocop:enable Metrics/AbcSize

  def get_building_ids_uvals(uvals, spreadsheet_type)
    buildings_ids = []
    @selected_buildings.each do |building|
      result = @report.uvals_for_public(building, spreadsheet_type)
      building_uvals = result[0]
      uvals.concat building_uvals
      buildings_ids << building.building_id
    end

    building_ids_with_service_codes2 = buildings_ids.collect do |b|
      services_per_building = uvals.select { |u| u[:building_id] == b }.collect { |u| u[:service_code] }
      { building_id: b.downcase, service_codes: services_per_building }
    end
    building_ids_with_service_codes2
  end
end
