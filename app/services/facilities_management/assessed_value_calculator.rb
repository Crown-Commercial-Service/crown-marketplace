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
    suppliers = @report.selected_suppliers(@report.current_lot).map { |s| { supplier_name: s['data']['supplier_name'], supplier_id: s['data']['supplier_id'] } }

    if @lot_number == '1a' && @procurement.eligible_for_da?
      suppliers.each do |supplier|
        @report.calculate_services_for_buildings supplier[:supplier_name]
        supplier.merge!(da_value: @report.direct_award_value)
      end
      suppliers.sort_by { |s| s[:da_value] }
    else
      suppliers.map { |s| s.merge!(da_value: 0) }
    end
  end
end
