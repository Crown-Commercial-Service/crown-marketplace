class FacilitiesManagement::AssessedValueCalculator
  attr_reader :assessed_value, :lot_number, :results

  def initialize(procurement_id)
    @procurement = FacilitiesManagement::Procurement.find(procurement_id)

    @report = FacilitiesManagement::SummaryReport.new(@procurement.id)
    @selected_buildings = @procurement.active_procurement_buildings
    @report.calculate_services_for_buildings
    @lot_number = @report.current_lot
    @assessed_value = @report.assessed_value
  end

  def sorted_list
    @results = {}
    supplier_names = @report.selected_suppliers(@report.current_lot).map { |s| s['data']['supplier_name'] }

    if @lot_number == '1a'
      supplier_names.each do |supplier_name|
        @report.calculate_services_for_buildings supplier_name
        @results[supplier_name] = @report.direct_award_value
      end
      @results.sort_by { |_k, v| v }
    else
      @results = supplier_names.map { |s| [s, 0] }
    end
  end
end
