class FacilitiesManagement::DirectAwardEligibleSuppliers
  def initialize(procurement_id)
    @procurement = FacilitiesManagement::Procurement.find(procurement_id)
  end

  def sorted_list
    @report = FacilitiesManagement::SummaryReport.new(@procurement.initial_call_off_start_date, @procurement.user.email, nil, @procurement)

    @selected_buildings = @procurement.active_procurement_buildings
    rates = CCS::FM::Rate.read_benchmark_rates
    @rate_card = CCS::FM::RateCard.latest
    @results = {}
    supplier_names = @rate_card.data[:Prices].keys
    supplier_names.each do |supplier_name|
      @report.calculate_services_for_buildings @selected_buildings, nil, rates, @rate_card, supplier_name, nil
      @results[supplier_name] = @report.direct_award_value
    end
    @procurement.update(lot_number: @report.current_lot, assessed_value: @report.assessed_value)
    @results.sort_by { |_k, v| v }
  end
end
