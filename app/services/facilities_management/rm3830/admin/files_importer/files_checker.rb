module FacilitiesManagement::RM3830
  module Admin
    class FilesImporter::FilesChecker < FacilitiesManagement::FilesImporter::FilesChecker
      def check_files
        check_supplier_data_file

        @errors
      end

      private

      def check_supplier_data_file
        read_spreadsheet(:supplier_data_file) do |supplier_data_workbook|
          if supplier_data_workbook.sheets == ['Prices', 'Variances']
            @errors << { error: 'pricing_sheet_headers_incorrect' } if supplier_data_workbook.sheet(0).row(1) != ['Supplier', 'Service Ref', 'Service Name', 'Unit of Measure', 'General office - Customer Facing', 'General office - Non Customer Facing', 'Call Centre Operations', 'Warehouses', 'Restaurant and Catering Facilities', 'Pre-School', 'Primary School', 'Secondary Schools', 'Special Schools', 'Universities and Colleges', 'Community - Doctors, Dentist, Health Clinic', 'Nursing and Care Homes', 'Direct Award Discount %']
            @errors << { error: 'variances_sheet_headers_incorrect' } if supplier_data_workbook.sheet(1).column(1) != ['Supplier', 'Management Overhead %', 'Corporate Overhead %', 'Profit %', 'London Location Variance Rate (%)', 'Cleaning Consumables per Building User (£)', 'TUPE Risk Premium (DA %)', 'Mobilisation Cost (DA %)']
          else
            @errors << { error: 'supplier_data_missing_sheets' }
          end
        end
      end
    end
  end
end
