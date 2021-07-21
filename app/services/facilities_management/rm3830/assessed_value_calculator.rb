module FacilitiesManagement::RM3830
  class AssessedValueCalculator
    attr_reader :assessed_value, :lot_number, :results

    def initialize(procurement_id)
      @procurement = Procurement.find(procurement_id)

      @report = SummaryReport.new(@procurement.id)
      @selected_buildings = @procurement.active_procurement_buildings
      @report.calculate_services_for_buildings
      @lot_number = @report.current_lot
      @assessed_value = @report.assessed_value
    end

    def sorted_list(eligible_for_da)
      suppliers = @report.selected_suppliers(@report.current_lot).map { |s| { supplier_id: s.supplier_id } }

      if @lot_number == '1a' && eligible_for_da
        suppliers.each do |supplier|
          @report.calculate_services_for_buildings supplier[:supplier_id]
          supplier.merge!(da_value: @report.direct_award_value)
        end
        suppliers.sort_by { |s| s[:da_value] }
      else
        suppliers.map { |s| s.merge!(da_value: 0) }
      end
    end
  end
end
