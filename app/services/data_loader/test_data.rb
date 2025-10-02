class DataLoader::TestData
  module FM
    module RM6378
      def self.import_data
        Rails.logger.info 'Importing FM RM6378 data'

        File.open('data/facilities_management/rm6378/dummy_supplier_data.json', 'r') do |file|
          Upload.upload!('RM6378', JSON.parse(file.read, symbolize_names: true))
        end
      end
    end
  end

  class << self
    private

    def empty_tables
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

    public

    def import_test_data
      empty_tables

      FM::RM6378.import_data
    end

    def import_test_data_for_framework_service(framework)
      empty_tables

      case framework
      when 'RM6378'
        FM::RM6378.import_data
      end
    end
  end
end
