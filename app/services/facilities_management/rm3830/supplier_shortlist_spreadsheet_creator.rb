module FacilitiesManagement
  module RM3830
    class SupplierShortlistSpreadsheetCreator < SupplierShortlistSpreadsheet
      def initialize(procurement_id)
        super(Procurement.find(procurement_id), 'Quick view search name')
        @region_codes = @procurement.region_codes
        @service_codes = @procurement.service_codes
      end

      private

      def set_data
        @regions = FacilitiesManagement::Region.where(code: @region_codes)
        @services = @service_codes.index_with { |code| Service.find_by(code:).name }

        @lot_1a_suppliers = suppliers_for_lot('1a')
        @lot_1b_suppliers = suppliers_for_lot('1b')
        @lot_1c_suppliers = suppliers_for_lot('1c')
      end

      def add_supplier_shortlists
        @workbook.add_worksheet(name: 'Supplier shortlists') do |sheet|
          sheet.add_row ['Quick view results', nil, nil], style: @styles[:heading_style], height: LARGE_ROW_HEIGHT
          sheet.add_row ['Here are the suppliers that can provide your services to your region(s). We are showing you potential suppliers from all three sub-lots, however, your procurement will fall into only one sub-lot dependent on your potential total contract value (which excludes billable works, optional extension periods and VAT).', nil, nil], style: @styles[:standard_column_style], height: LARGE_ROW_HEIGHT
          sheet.add_row ['To be placed compliantly into a sub-lot, please refer to Framework Schedule 7 - Call-off Procedure and Award Criteria', nil, nil], style: @styles[:standard_column_style], height: LARGE_ROW_HEIGHT
          sheet.add_row [], height: LARGE_ROW_HEIGHT

          sheet.add_row ['Suppliers shortlists', nil, nil], style: @styles[:underlined_heading_style], height: STANDARD_ROW_HEIGHT
          sheet.add_row ['Sub-lot 1a', 'Sub-lot 1b', 'Sub-lot 1c'], style: @styles[:heading_style], height: STANDARD_ROW_HEIGHT
          sheet.add_row ['Total contract value: up to £7m', 'Total contract value: between £7m - £50m', 'Total contract value: over £50m'], style: @styles[:heading_style], height: STANDARD_ROW_HEIGHT

          supplier_names_rows.each do |supplier_names_row|
            sheet.add_row supplier_names_row, style: @styles[:supplier_shortlist_style], height: STANDARD_ROW_HEIGHT
          end

          sheet.merge_cells 'A2:C2'
          sheet.merge_cells 'A3:C3'

          sheet.column_widths(50, 50, 50)
        end
      end

      def supplier_names_rows
        supplier_names = [@lot_1a_suppliers, @lot_1b_suppliers, @lot_1c_suppliers]

        max_size = supplier_names.map(&:size).max

        max_size.times.map { |index| [supplier_names[0][index], supplier_names[1][index], supplier_names[2][index]] }
      end

      def suppliers_for_lot(lot)
        SupplierDetail.long_list_suppliers_lot(@region_codes, @service_codes, lot).pluck('name')
      end
    end
  end
end
