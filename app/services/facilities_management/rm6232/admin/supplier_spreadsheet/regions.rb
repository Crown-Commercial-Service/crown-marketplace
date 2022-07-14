module FacilitiesManagement::RM6232
  module Admin
    class SupplierSpreadsheet::Regions < FacilitiesManagement::RM6232::Admin::SupplierSpreadsheet
      private

      def add_styles
        super do |styles|
          @styles[:heading_style] = styles.add_style sz: 12, b: true, bg_color: 'FBE4D5', fg_color: '000000', alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '000000' }
          @styles[:normal_row]    = styles.add_style sz: 12, b: false, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '000000' }
          @styles[:row_height]    = 25
        end
      end

      def create_spreadsheet
        %w[1 2 3].each do |lot_number|
          %w[a b c].each do |lot_letter|
            lot_code = "#{lot_number}#{lot_letter}"

            suppliers = lot_suppliers(lot_code)

            @workbook.add_worksheet(name: "Lot #{lot_code}") do |sheet|
              sheet.add_row ['Supplier', 'DUNS Number'] + region_codes, style: @styles[:heading_style], height: @styles[:row_height]

              suppliers.each do |supplier|
                supplier_regions_marked = region_codes.map { |region_code| 'X' if supplier['region_codes'].include?(region_code) }
                sheet.add_row [supplier['supplier_name'], supplier['duns']] + supplier_regions_marked, style: @styles[:normal_row], height: @styles[:row_height], types: [:string] * NUMBER_OF_COLUMNS
              end
            end
          end
        end
      end

      def region_codes
        @region_codes ||= FacilitiesManagement::Region.all.map(&:code)[0..-2] + ['NC01', 'OS01']
      end

      NUMBER_OF_COLUMNS = 78
    end
  end
end
