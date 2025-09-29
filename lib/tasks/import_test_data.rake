module ImportTestData
  module FM
    module RM6378
      def self.import_data
        puts 'Importing FM RM6378 data'

        File.open('data/facilities_management/rm6378/dummy_supplier_data.json', 'r') do |file|
          Upload.upload!('RM6378', JSON.parse(file.read, symbolize_names: true))
        end
      end
    end
  end

  def self.empty_tables
    ActiveRecord::Base.connection.truncate_tables(
      :suppliers,
      :supplier_frameworks,
      :supplier_framework_lots,
      :supplier_framework_contact_details,
      :supplier_framework_addresses,
      :supplier_framework_lot_jurisdictions,
      :supplier_framework_lot_services,
      :supplier_framework_lot_rates,
      :supplier_framework_lot_branches,
    )
  end

  def self.import_test_data
    empty_tables

    FM::RM6378.import_data
  end

  def self.import_test_data_for_framework_service(framework)
    empty_tables

    case framework
    when 'RM6378'
      FM::RM6378.import_data
    end
  end
end

namespace :db do
  desc 'Imports test data into the test environment for cucumber tests'
  task import_test_data: :environment do
    if Rails.env.test?
      puts 'Importing the supplier test data'
      ImportTestData.import_test_data
      puts 'Finished supplier test data import'
    end
  end

  desc 'Imports test data for a specific framework into the test environment for cucumber tests'
  task :import_test_data_for_framework_service, [:framework] => :environment do |_t, args|
    if Rails.env.test?
      puts "Importing the supplier test data for #{args[:framework]}"
      ImportTestData.import_test_data_for_framework_service(args[:framework])
      puts "Finished supplier test data import for #{args[:framework]}"
    end
  end

  desc 'Imports test data into the development environment'
  task import_test_data_to_development: :environment do
    if Rails.env.development?
      puts 'Importing the supplier test data to development'
      ImportTestData.import_test_data
      puts 'Finished supplier test data import'
    end
  end
end
