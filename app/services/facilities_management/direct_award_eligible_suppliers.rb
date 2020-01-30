class FacilitiesManagement::DirectAwardEligibleSuppliers
  attr_reader :assessed_value, :lot_number

  def initialize(procurement_id)
    @procurement = FacilitiesManagement::Procurement.find(procurement_id)

    @report = FacilitiesManagement::SummaryReport.new(nil, @procurement.user.email, nil, @procurement)

    @selected_buildings = @procurement.active_procurement_buildings
    @rates = CCS::FM::Rate.read_benchmark_rates
    @rate_card = CCS::FM::RateCard.latest
    @results = {}
    @report.calculate_services_for_buildings @selected_buildings, nil, @rates, @rate_card, nil, nil
    @lot_number = @report.current_lot
    @assessed_value = @report.assessed_value
  end

  def sorted_list
    supplier_names = @rate_card.data[:Prices].keys
    supplier_names.each do |supplier_name|
      @report.calculate_services_for_buildings @selected_buildings, nil, @rates, @rate_card, supplier_name, nil
      @results[supplier_name] = @report.direct_award_value
    end

    @results.sort_by { |_k, v| v }
  end
end
