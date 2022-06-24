module FM::RM6232
  module Suppliers
    def self.truncate_tables
      FacilitiesManagement::RM6232::Supplier::LotData.destroy_all
      FacilitiesManagement::RM6232::Supplier.destroy_all
    end

    def self.import_supplier_details
      FM::RM6232::SupplierDetailsImport.new.import_data_from_spreadsheet
    end

    def self.import_supplier_services
      FM::RM6232::ServiceDataImport.new.import_data_from_spreadsheet
    end

    def self.import_supplier_regions
      FM::RM6232::RegionDataImport.new.import_data_from_spreadsheet
    end
  end
end

module FM::RM6232
  class DataImport
    def initialize(test_filename, data_import_type)
      @test_filename = test_filename
      @data_import_type = data_import_type
    end

    def import_data_from_spreadsheet
      supplier_data = {}

      read_spreadsheet do |supplier_spreadsheet|
        supplier_data = get_supplier_data(supplier_spreadsheet)
      end

      write_supplier_data(supplier_data)
    end

    private

    def spreadsheet_path
      if Rails.env.production?
        puts "RM6232 supplier #{@data_import_type} from file in aws"
        tmpfile = Tempfile.new(["rm6232_supplier_#{@data_import_type}_data", '.xlsx'], binmode: true)
        tmpfile.close

        aws_file(ENV.fetch("RM6232_SUPPLIER_#{@data_import_type.upcase}_KEY")).get(response_target: tmpfile.path)
        tmpfile.path
      else
        puts "RM6232 supplier #{@data_import_type} from file in code"
        Rails.root.join('data', 'facilities_management', 'rm6232', @test_filename)
      end
    end

    def aws_file(object_key)
      s3_resource = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
      s3_resource.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(object_key)
    end

    def read_spreadsheet
      workbook = Roo::Spreadsheet.open(spreadsheet_path, extension: :xlsx)

      yield(workbook)

      workbook.close
    end

    def get_data_from_lot_sheets(spreadsheet)
      @supplier_data = []

      %w[1 2 3].each do |lot_number|
        %w[a b c].each do |lot_letter|
          lot_code = "#{lot_number}#{lot_letter}"

          lot_sheet = spreadsheet.sheet("Lot #{lot_code}")

          yield(lot_sheet, lot_code)
        end
      end

      @supplier_data
    end

    def supplier_duns_to_id
      @supplier_duns_to_id ||= FacilitiesManagement::RM6232::Supplier.pluck(:duns, :id).to_h
    end
  end

  class SupplierDetailsImport < DataImport
    def initialize
      super('RM6232 Suppliers Details (for Dev & Test).xlsx', 'details')
    end

    def import_data_from_spreadsheet
      read_spreadsheet do |supplier_details|
        attributes = %i[supplier_name sme duns registration_number address_line_1 address_line_2 address_town address_county address_postcode]

        supplier_details.sheet(0).drop(1).each do |row|
          row_data = attributes.zip(row.map(&:to_s).map(&:strip)).to_h
          row_data[:sme] = row_data[:sme].downcase.include?('yes')

          FacilitiesManagement::RM6232::Supplier.create(**row_data)
        end
      end
    end
  end

  class ServiceDataImport < DataImport
    def initialize
      super('RM6232 Supplier Services (for Dev & Test).xlsx', 'services')
    end

    private

    def get_supplier_data(supplier_services_spreadsheet)
      get_data_from_lot_sheets(supplier_services_spreadsheet) do |lot_sheet, lot_code|
        service_to_index = lot_sheet.column(2)[5..].map do |unformatted_service_code|
          next if unformatted_service_code.nil?

          "#{unformatted_service_code[1]}.#{unformatted_service_code[2..]}"
        end

        @supplier_data += supplier_services_from_sheet(lot_sheet, lot_code, service_to_index)
      end
    end

    def write_supplier_data(supplier_data)
      supplier_data.each do |supplier_service_data|
        supplier_id = supplier_duns_to_id[supplier_service_data[:duns]]

        FacilitiesManagement::RM6232::Supplier::LotData.create(facilities_management_rm6232_supplier_id: supplier_id, lot_code: supplier_service_data[:lot_code], service_codes: supplier_service_data[:service_codes])
      end
    end

    def supplier_services_from_sheet(lot_sheet, lot_code, service_to_index)
      (5..lot_sheet.last_column).map do |column_number|
        column = lot_sheet.column(column_number)

        supplier_duns = column[2].to_s

        supplier_service_codes = [] + core_serivce_codes[lot_code[0]]

        column[5..].each.with_index do |cell, index|
          supplier_service_codes << service_to_index[index] if cell&.downcase&.strip == 'yes'
        end

        { duns: supplier_duns, lot_code: lot_code, service_codes: supplier_service_codes }
      end
    end

    def core_serivce_codes
      @core_serivce_codes ||= {
        '1' => FacilitiesManagement::RM6232::WorkPackage.selectable.map { |work_package| work_package.supplier_services.where(total: true, core: true).pluck(:code) }.flatten,
        '2' => FacilitiesManagement::RM6232::WorkPackage.selectable.map { |work_package| work_package.supplier_services.where(hard: true, core: true).pluck(:code) }.flatten,
        '3' => FacilitiesManagement::RM6232::WorkPackage.selectable.map { |work_package| work_package.supplier_services.where(soft: true, core: true).pluck(:code) }.flatten
      }
    end
  end

  class RegionDataImport < DataImport
    def initialize
      super('RM6232 Supplier Regions (for Dev & Test).xlsx', 'regions')
    end

    private

    def get_supplier_data(supplier_regions_spreadsheet)
      get_data_from_lot_sheets(supplier_regions_spreadsheet) do |regions_sheet, lot_code|
        @supplier_data += supplier_regions_from_sheet(regions_sheet, lot_code)
      end
    end

    def write_supplier_data(supplier_data)
      supplier_data.each do |supplier_region_data|
        supplier_id = supplier_duns_to_id[supplier_region_data[:duns]]

        FacilitiesManagement::RM6232::Supplier::LotData.find_by(facilities_management_rm6232_supplier_id: supplier_id, lot_code: supplier_region_data[:lot_code]).update(region_codes: supplier_region_data[:region_codes])
      end
    end

    def supplier_regions_from_sheet(regions_sheet, lot_code)
      (2..regions_sheet.last_row).map do |row_number|
        row = regions_sheet.row(row_number)
        supplier_duns = row[1].to_s

        supplier_region_codes = []

        row[2..].each.with_index do |cell, index|
          supplier_region_codes << region_codes[index] if cell&.downcase&.strip == 'x'
        end

        { duns: supplier_duns, lot_code: lot_code, region_codes: supplier_region_codes }
      end
    end

    def region_codes
      @region_codes ||= FacilitiesManagement::Region.all.map(&:code)[0..-2] + ['NC01', 'OS01']
    end
  end
end

namespace :db do
  namespace :rm6232 do
    desc 'Imports the suppliers into the database'
    task import_suppliers: :environment do
      DistributedLocks.distributed_lock(193) do
        ActiveRecord::Base.transaction do
          FM::RM6232::Suppliers.truncate_tables
          FM::RM6232::Suppliers.import_supplier_details
          FM::RM6232::Suppliers.import_supplier_services
          FM::RM6232::Suppliers.import_supplier_regions
        rescue ActiveRecord::Rollback => e
          logger.error e.message
        end
      end
    end

    desc 'add Suppliers for RM6232 to the database'
    task static: :import_suppliers do
    end
  end

  desc 'add Suppliers for RM6232 to the database'
  task static: :'rm6232:import_suppliers' do
  end
end
