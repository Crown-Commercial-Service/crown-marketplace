class FacilitiesManagement::DirectAwardEligibleSuppliers
  attr_reader :assessed_value, :lot_number

  def initialize(procurement_id)
    @procurement = FacilitiesManagement::Procurement.find(procurement_id)

    @report = FacilitiesManagement::SummaryReport.new(@procurement)
    @selected_buildings = @procurement.active_procurement_buildings
    @report.calculate_services_for_buildings @procurement.active_procurement_buildings
    @lot_number = @report.current_lot
    @assessed_value = @report.assessed_value
  end

  def sorted_list
    @results = {}
    supplier_names = @report.selected_suppliers(@report.current_lot).map { |s| s['data']['supplier_name'] }
    supplier_names.each do |supplier_name|
      @report.calculate_services_for_buildings @selected_buildings, nil, supplier_name
      @results[supplier_name] = @report.direct_award_value
    end

    @results.sort_by { |_k, v| v }
  end
end
