module FacilitiesManagement::RM6232
  module Admin
    class SupplierSpreadsheet::Details < FacilitiesManagement::RM6232::Admin::SupplierSpreadsheet
      def initialize(supplier_data, filename = nil, active_required = false)
        super(supplier_data, filename)
        @active_required = active_required
      end

      private

      def add_styles
        super do |styles|
          @styles[:heading_style] = styles.add_style sz: 12, b: true, bg_color: '4571C4', fg_color: 'FFFFFF', alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '000000' }
          @styles[:even_row]      = styles.add_style sz: 12, b: false, bg_color: 'D8E2F2', fg_color: '000000', alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '000000' }
          @styles[:odd_row]       = styles.add_style sz: 12, b: false, bg_color: 'FFFFFF', fg_color: '000000', alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '000000' }
          @styles[:row_height]    = 25
        end
      end

      def create_spreadsheet
        @workbook.add_worksheet(name: 'RM6232 Suppliers Details') do |sheet|
          sheet.add_row headers, style: @styles[:heading_style], height: @styles[:row_height]

          @supplier_data.sort_by { |supplier| supplier['supplier_name'] }.each_with_index do |supplier, index|
            row_data = get_row_data(supplier)

            style = index.even? ? @styles[:even_row] : @styles[:odd_row]
            sheet.add_row row_data.values, style: style, height: @styles[:row_height], types: [:string] * attributes.length
          end

          sheet.column_widths(*column_widths)
        end
      end

      def get_row_data(supplier)
        row_data = supplier.slice(*attributes)
        row_data['sme'] = row_data['sme'] ? 'Yes' : 'No'
        row_data['active'] = row_data['active'] || row_data['active'].nil? ? 'Active' : 'Inactive' if @active_required

        row_data
      end

      def attributes
        @attributes ||= @active_required ? ATTRIBUTES + ['active'] : ATTRIBUTES
      end

      def headers
        @headers ||= @active_required ? HEADERS + ['Status'] : HEADERS
      end

      def column_widths
        @column_widths ||= @active_required ? COLUMN_WIDTHS + [10] : COLUMN_WIDTHS
      end

      HEADERS = ['Supplier name', 'SME', 'DUNS number', 'Registration number', 'Address line 1', 'Address line 2', 'Town', 'County', 'Postcode'].freeze
      ATTRIBUTES = ['supplier_name', 'sme', 'duns', 'registration_number', 'address_line_1', 'address_line_2', 'address_town', 'address_county', 'address_postcode'].freeze
      COLUMN_WIDTHS = [20, 5, 15, 20, 25, 25, 20, 20, 15].freeze
    end
  end
end
