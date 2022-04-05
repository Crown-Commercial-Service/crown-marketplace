module FM::RM6232
  module GenerateSupplierDetails
    def self.truncate_tables
      FacilitiesManagement::RM6232::Supplier.destroy_all
    end

    def self.generate_suppliers_with_details
      50.times do
        FacilitiesManagement::RM6232::Supplier.create(supplier_name: Faker::Company.unique.name)
      end

      suppliers = FacilitiesManagement::RM6232::Supplier.all

      generate_supplier_details(suppliers)
    end

    def self.generate_supplier_details(suppliers)
      Faker::Config.locale = 'en-GB'

      suppliers.each do |supplier|
        data = {
          contact_name: Faker::Name.unique.name,
          contact_email: Faker::Internet.unique.email,
          contact_phone: Faker::PhoneNumber.unique.phone_number,
          sme: rand > 0.75,
          duns: Faker::Company.unique.duns_number.gsub('-', ''),
          registration_number: "0#{rand(100000...999999)}",
          address_line_1: Faker::Address.street_address,
          address_line_2: rand > 0.5 ? Faker::Address.street_name : '',
          address_town: Faker::Address.city,
          address_county: Faker::Address.county,
          address_postcode: Faker::Address.postcode,
        }

        supplier.update(**data)
      end
    end

    def self.convert_to_spreadsheet
      set_up_spreadsheet
      create_spreadsheet
      save_spreadsheet
    end

    def self.set_up_spreadsheet
      @package = Axlsx::Package.new
      @workbook = @package.workbook

      @styles = {}
      @workbook.styles do |styles|
        @styles[:heading_style] = styles.add_style sz: 12, b: true, bg_color: '4571C4', fg_color: 'FFFFFF', alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '000000' }
        @styles[:even_row]      = styles.add_style sz: 12, b: false, bg_color: 'D8E2F2', fg_color: '000000', alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '000000' }
        @styles[:odd_row]       = styles.add_style sz: 12, b: false, bg_color: 'FFFFFF', fg_color: '000000', alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '000000' }
        @styles[:row_height]    = 25
      end
    end

    def self.create_spreadsheet
      @workbook.add_worksheet(name: 'RM6232 Suppliers Details') do |sheet|
        sheet.add_row HEADERS, style: @styles[:heading_style], height: @styles[:row_height]

        FacilitiesManagement::RM6232::Supplier.order(:supplier_name).each_with_index do |supplier, index|
          row_data = supplier.attributes.slice(*ATTRIBUTES)
          row_data['sme'] = row_data['sme'] ? 'Yes' : 'No'

          style = index.even? ? @styles[:even_row] : @styles[:odd_row]
          sheet.add_row row_data.values, style: style, height: @styles[:row_height], types: [:string] * ATTRIBUTES.length
        end

        sheet.column_widths(*COLUMN_WIDTHS)
      end
    end

    HEADERS = ['Supplier ID', 'Supplier name', 'Contact name', 'Contact email', 'Contact phone number', 'SME', 'DUNS number', 'Registration number', 'Address line 1', 'Address line 2', 'Town', 'County', 'Postcode'].freeze
    ATTRIBUTES = ['id', 'supplier_name', 'contact_name', 'contact_email', 'contact_phone', 'sme', 'duns', 'registration_number', 'address_line_1', 'address_line_2', 'address_town', 'address_county', 'address_postcode'].freeze
    COLUMN_WIDTHS = [42, 20, 25, 35, 23, 5, 15, 20, 25, 25, 20, 20, 15].freeze

    def self.save_spreadsheet
      file_path = Rails.root.join('data', 'facilities_management', 'rm6232', 'RM6232 Suppliers Details (for Dev & Test).xlsx')

      File.write(file_path, @package.to_stream.read, binmode: true)
    end
  end
end

# This task was created to generate the test data
# You should need to run it again as it will change the tests data and break tests
namespace :db do
  namespace :rm6232 do
    desc 'Generate the supplier details and save to xlsx'
    task generate_supplier_details: :environment do
      DistributedLocks.distributed_lock(192) do
        ActiveRecord::Base.transaction do
          FM::RM6232::GenerateSupplierDetails.truncate_tables
          FM::RM6232::GenerateSupplierDetails.generate_suppliers_with_details
          FM::RM6232::GenerateSupplierDetails.convert_to_spreadsheet
        rescue ActiveRecord::Rollback => e
          logger.error e.message
        end
      end
    end

    desc 'Part of generating the full supplier details'
    task generate_suppliers: :generate_supplier_details do
    end
  end
end
