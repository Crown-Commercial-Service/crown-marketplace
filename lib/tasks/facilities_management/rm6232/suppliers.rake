module FM::RM6232
  module Suppliers
    def self.truncate_tables
      FacilitiesManagement::RM6232::Supplier::LotData.destroy_all
      FacilitiesManagement::RM6232::Supplier.destroy_all
    end

    def self.supplier_data
      if Rails.env.production?
        puts 'RM6232 supplier data from file in aws'
        JSON aws_file
      else
        puts 'RM6232 supplier data from file in code'
        JSON File.read('data/facilities_management/rm6232/dummy_supplier_data.json')
      end
    end

    def self.aws_file
      s3_resource = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
      object = s3_resource.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(ENV['JSON_RM6232_SUPPLIER_DATA_KEY'])
      object.get.body.string
    end

    def self.import_suppliers
      supplier_data.each do |data|
        supplier = FacilitiesManagement::RM6232::Supplier.create(data.except('lot_data'))

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
          FM::RM6232::Suppliers.import_suppliers
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
