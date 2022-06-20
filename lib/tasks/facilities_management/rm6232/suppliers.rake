module FM::RM6232
  module Suppliers
    def self.truncate_tables
      FacilitiesManagement::RM6232::Supplier::LotData.destroy_all
      FacilitiesManagement::RM6232::Supplier.destroy_all
    end

    def self.supplier_details_path
      if Rails.env.production?
        puts 'RM6232 supplier details from file in aws'
        tmpfile = Tempfile.new(['rm6232_supplier_details_data', '.xlsx'], binmode: true)
        tmpfile.close

        aws_file(ENV['RM6232_SUPPLIER_DETAILS_KEY']).get(response_target: tmpfile.path)
        tmpfile.path
      else
        puts 'RM6232 supplier details from file in code'
        Rails.root.join('data', 'facilities_management', 'rm6232', 'RM6232 Suppliers Details (for Dev & Test).xlsx')
      end
    end

    def self.supplier_lot_data
      if Rails.env.production?
        puts 'RM6232 supplier lot data from file in aws'
        JSON aws_file(ENV['RM6232_SUPPLIER_LOT_DATA_KEY']).get.body.string
      else
        puts 'RM6232 supplier lot data from file in code'
        JSON File.read(Rails.root.join('data', 'facilities_management', 'rm6232', 'dummy_supplier_data.json'))
      end
    end

    def self.aws_file(object_key)
      s3_resource = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
      s3_resource.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(object_key)
    end

    def self.import_supplier_details
      attributes = %i[supplier_name sme duns registration_number address_line_1 address_line_2 address_town address_county address_postcode]

      supplier_details = Roo::Spreadsheet.open(supplier_details_path, extension: :xlsx)

      supplier_details.sheet(0).drop(1).each do |row|
        row_data = attributes.zip(row.map(&:to_s).map(&:strip)).to_h
        row_data[:sme] = row_data[:sme].downcase.include?('yes')

        FacilitiesManagement::RM6232::Supplier.create(**row_data)
      end

      supplier_details.close
    end

    def self.import_supplier_lot_data
      supplier_lot_data.each do |data|
        supplier = FacilitiesManagement::RM6232::Supplier.find_by(duns: data['id'])

        data['lot_data'].each do |lot_data|
          FacilitiesManagement::RM6232::Supplier::LotData.create(supplier: supplier, **lot_data)
        end
      end
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
          FM::RM6232::Suppliers.import_supplier_lot_data
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
