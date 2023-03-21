module FM::RM6232
  module GenerateSpreadsheets
    def self.convert_supplier_details_to_spreadsheet
      supplier_data = FacilitiesManagement::RM6232::Supplier.order(:supplier_name).map(&:attributes)

      filename = 'RM6232 Suppliers Details (for Dev & Test).xlsx'
      supplier_details_spreadsheet = FacilitiesManagement::RM6232::Admin::SupplierSpreadsheet::Details.new(supplier_data, filename)
      supplier_details_spreadsheet.build
      supplier_details_spreadsheet.save_spreadsheet
    end

    def self.convert_supplier_lot_data_to_spreadsheets
      supplier_data = FacilitiesManagement::RM6232::Supplier.order(:supplier_name).map do |supplier|
        lot_data = supplier.lot_data.map(&:attributes)

        supplier_data = supplier.attributes
        supplier_data['lot_data'] = lot_data

        supplier_data
      end

      filename = 'RM6232 Supplier Services (for Dev & Test).xlsx'
      supplier_services_spreadsheet = FacilitiesManagement::RM6232::Admin::SupplierSpreadsheet::Services.new(supplier_data, filename)
      supplier_services_spreadsheet.build
      supplier_services_spreadsheet.save_spreadsheet

      filename = 'RM6232 Supplier Regions (for Dev & Test).xlsx'
      supplier_regions_spreadsheet = FacilitiesManagement::RM6232::Admin::SupplierSpreadsheet::Regions.new(supplier_data, filename)
      supplier_regions_spreadsheet.build
      supplier_regions_spreadsheet.save_spreadsheet
    end

    def self.generate_templates_zip
      supplier_details_spreadsheet = FacilitiesManagement::RM6232::Admin::SupplierSpreadsheet::Details.new([])
      supplier_details_spreadsheet.build

      supplier_services_spreadsheet = FacilitiesManagement::RM6232::Admin::SupplierSpreadsheet::Services.new([])
      supplier_services_spreadsheet.build

      supplier_regions_spreadsheet = FacilitiesManagement::RM6232::Admin::SupplierSpreadsheet::Regions.new([])
      supplier_regions_spreadsheet.build

      file_stream = Zip::OutputStream.write_buffer do |zip|
        zip.put_next_entry 'RM6232 Suppliers Details.xlsx'
        zip.print supplier_details_spreadsheet.to_xlsx

        zip.put_next_entry 'RM6232 Suppliers Services.xlsx'
        zip.print supplier_services_spreadsheet.to_xlsx

        zip.put_next_entry 'RM6232 Suppliers Regions.xlsx'
        zip.print supplier_regions_spreadsheet.to_xlsx
      end

      file_stream.rewind

      file_path = Rails.public_path.join('facilities-management', 'rm6232', 'Supplier spreadsheet templates.zip')

      File.write(file_path, file_stream.read)
    end
  end
end

namespace :db do
  namespace :rm6232 do
    desc 'Generate spreadsheets from the current supplier details'
    task generate_supplier_details_spreadsheet: :environment do
      FM::RM6232::GenerateSpreadsheets.convert_supplier_details_to_spreadsheet
    end

    desc 'Generate spreadsheets from the current supplier lot data'
    task generate_supplier_lot_data_spreadsheets: :environment do
      FM::RM6232::GenerateSpreadsheets.convert_supplier_lot_data_to_spreadsheets
    end

    desc 'Part of generating the full supplier spreadsheets'
    task generate_supplier_spreadsheets: %i[generate_supplier_details_spreadsheet generate_supplier_lot_data_spreadsheets]

    desc 'Generate spreadsheet templates. This should be run if the service data is changed'
    task generate_template_zip: :environment do
      FM::RM6232::GenerateSpreadsheets.generate_templates_zip
    end
  end
end
