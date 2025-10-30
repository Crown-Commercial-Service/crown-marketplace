module FacilitiesManagement
  module RM6378
    class SupplierShortlistSpreadsheetCreator < SupplierShortlistSpreadsheet
      def initialize(procurement_id)
        super(Procurement.find(procurement_id), 'Search name')
      end

      private

      def set_data
        @regions = @procurement.jurisdictions
        @services = @procurement.services.pluck(:number, :name).to_h
        @supplier_names = @procurement.suppliers.pluck('supplier.name')
      end

      def add_regions
        @workbook.add_worksheet(name: 'Regions') do |sheet|
          sheet.add_row ['ITL Code', 'Region Name'], style: @styles[:bordered_heading_style], height: LARGE_ROW_HEIGHT

          @regions.each do |region|
            sheet.add_row [region.id, region.name], style: @styles[:standard_bordered_column_style], height: LARGE_ROW_HEIGHT
          end

          sheet.column_widths(*COLUMN_WIDTHS)
        end
      end

      def add_supplier_shortlists
        @workbook.add_worksheet(name: 'Supplier shortlists') do |sheet|
          sheet.add_row ['Supplier Shortlist and eligible Lot', nil], style: @styles[:heading_style], height: LARGE_ROW_HEIGHT
          sheet.add_row ['Reference number:', @procurement.contract_number], style: @styles[:heading_style], height: LARGE_ROW_HEIGHT
          sheet.add_row ['Estimated annual cost:', @procurement.annual_contract_value], style: @styles[:heading_style], height: LARGE_ROW_HEIGHT
          sheet.add_row ['Based on your service and region requirements given, and your estimated annual cost, this procurement would be eligible for the Lot and shortlist of suppliers as listed below.', nil, nil], style: @styles[:standard_column_style], height: LARGE_ROW_HEIGHT
          sheet.add_row [], height: LARGE_ROW_HEIGHT

          sheet.add_row ['Suppliers shortlists', nil], style: @styles[:underlined_heading_style], height: STANDARD_ROW_HEIGHT
          sheet.add_row ["Sub-lot #{@procurement.lot.number}", nil], style: @styles[:heading_style], height: STANDARD_ROW_HEIGHT

          @supplier_names.each do |supplier_name|
            sheet.add_row [sanitize_string_for_excel(supplier_name), nil], style: @styles[:supplier_shortlist_style], height: STANDARD_ROW_HEIGHT
          end

          style_add_supplier_shortlists_sheet(sheet)
        end
      end

      def style_add_supplier_shortlists_sheet(sheet)
        sheet['B2'].style = @styles[:standard_column_style]
        sheet['B3'].style = @styles[:currency_column_style]
        sheet.merge_cells 'A4:B4'

        sheet.column_widths(50, 50, 50)
      end
    end
  end
end
