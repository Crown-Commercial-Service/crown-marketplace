module FacilitiesManagement::RM6232
  module Admin
    class SupplierSpreadsheet
      def initialize(supplier_data, filename = nil)
        @supplier_data = supplier_data
        @filename = filename
      end

      def build
        @package = Axlsx::Package.new
        @workbook = @package.workbook

        add_styles
        create_spreadsheet
      end

      def to_xlsx
        @package.to_stream.read
      end

      def save_spreadsheet
        file_path = Rails.root.join('data', 'facilities_management', 'rm6232', @filename)

        File.write(file_path, to_xlsx, binmode: true)
      end

      private

      def add_styles(&)
        @styles = {}

        @workbook.styles(&)
      end

      def lot_suppliers(lot_code)
        suppliers = @supplier_data.map do |supplier|
          supplier_lot_data = supplier['lot_data'].find { |lot_data| lot_data['lot_code'] == lot_code } if supplier['lot_data'].any?

          next unless supplier_lot_data

          {
            'supplier_name' => supplier['supplier_name'],
            'duns' => supplier['duns'],
            'service_codes' => supplier_lot_data['service_codes'],
            'region_codes' => supplier_lot_data['region_codes']
          }
        end

        suppliers.compact_blank.sort_by { |supplier| supplier['supplier_name'] }
      end
    end
  end
end
