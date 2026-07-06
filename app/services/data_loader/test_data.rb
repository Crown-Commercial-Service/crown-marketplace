class DataLoader::TestData
  module FM
    module RM3830
      def self.import_data
        Rails.logger.info 'Importing FM RM3830 data'

        DistributedLocks.distributed_lock(3830) do
          ActiveRecord::Base.transaction do
            FacilitiesManagement::RM3830::SupplierDetail.destroy_all
            FacilitiesManagement::RakeModules::SupplierData.fm_suppliers
            FacilitiesManagement::RakeModules::SupplierData.fm_supplier_contact_details
            FacilitiesManagement::RM3830::Admin::FilesImporter.new.import_test_data
          rescue ActiveRecord::Rollback => e
            logger.error e.message
          end
        end
      end
    end

    module RM6232
      def self.import_data
        Rails.logger.info 'Importing FM RM6232 data'

        DistributedLocks.distributed_lock(6232) do
          ActiveRecord::Base.transaction do
            FacilitiesManagement::RM6232::Admin::SupplierData.destroy_all
            FacilitiesManagement::RM6232::Admin::FilesImporter.new.import_test_data
          rescue ActiveRecord::Rollback => e
            logger.error e.message
          end
        end

        Rails.logger.info 'Making RM6232 live'
        Framework.find('RM6232').update(expires_at: 1.day.from_now)
      end
    end

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

    FRAMEWORK_TO_MODULE = {
      'RM3830' => FM::RM3830,
      'RM6232' => FM::RM6232,
      'RM6378' => FM::RM6378,
    }.freeze

    public

    def import_test_data
      empty_tables

      FRAMEWORK_TO_MODULE.each_value(&:import_data)
    end

    def import_test_data_for_framework_service(framework)
      empty_tables

      FRAMEWORK_TO_MODULE[framework].import_data
    end
  end
end
