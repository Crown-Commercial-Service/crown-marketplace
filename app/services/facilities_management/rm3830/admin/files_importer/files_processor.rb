module FacilitiesManagement::RM3830
  module Admin
    class FilesImporter::FilesProcessor < FacilitiesManagement::FilesImporter::FilesProcessor
      def process_files
        process_supplier_data_file

        @supplier_data
      end

      private

      def process_supplier_data_file
        @supplier_data = { 'Prices' => lot_1a_suppliers, 'Discounts' => lot_1a_suppliers, 'Variances' => lot_1a_suppliers }

        read_spreadsheet(:supplier_data_file) do |supplier_data_workbook|
          add_prices(supplier_data_workbook.sheet('Prices'))
          add_variances(supplier_data_workbook.sheet('Variances'))
        end
      end

      def lot_1a_suppliers
        SupplierDetail.suppliers_offering_lot('1a').index_with { {} }
      end

      def add_prices(sheet)
        labels = sheet.row(1)[0..-2]
        last_row = sheet.last_row

        (2..last_row).each do |row_number|
          row = sheet.row(row_number)
          rate_card = labels.zip(row).to_h

          next unless rate_card['Service Ref']

          @supplier_data['Prices'][rate_card['Supplier']] ||= {}

          @supplier_data['Prices'][rate_card['Supplier']][rate_card['Service Ref']] = rate_card
          add_discounts(row.last, rate_card)
        end
      end

      def add_discounts(discount, rate_card)
        @supplier_data['Discounts'][rate_card['Supplier']] ||= {}

        @supplier_data['Discounts'][rate_card['Supplier']][rate_card['Service Ref']] = { 'Disc %' => discount.try(:abs) || discount }.merge(rate_card.slice('Supplier', 'Service Ref', 'Service Name'))
      end

      def add_variances(sheet)
        labels = sheet.column(1)
        last_column = sheet.last_column

        (2..last_column).each do |column_number|
          column = sheet.column(column_number)

          rate_card = labels.zip(column).to_h

          @supplier_data['Variances'][rate_card['Supplier']] ||= {}

          @supplier_data['Variances'][rate_card['Supplier']] = rate_card
        end
      end
    end
  end
end
