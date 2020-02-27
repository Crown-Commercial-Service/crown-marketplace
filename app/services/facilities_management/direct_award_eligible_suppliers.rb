class FacilitiesManagement::DirectAwardEligibleSuppliers
  attr_reader :assessed_value, :lot_number

  def initialize(procurement_id)
    @procurement = FacilitiesManagement::Procurement.find(procurement_id)

    @report = FacilitiesManagement::SummaryReport.new(@procurement)
    @report.calculate_services_for_buildings @procurement.active_procurement_buildings
    @lot_number = @report.current_lot
    @assessed_value = @report.assessed_value
  end

  def sorted_list
    supplier_names = CCS::FM::RateCard.latest.data[:Prices].keys
    supplier_names.each do |supplier_name|
      @report.calculate_services_for_buildings @selected_buildings, nil, supplier_name
      @results[supplier_name] = @report.direct_award_value
    end

    @results.sort_by { |_k, v| v }
  end
end
