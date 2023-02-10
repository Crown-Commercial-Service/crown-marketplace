namespace :db do
  namespace :rm6232 do
    desc 'Imports the suppliers into the database'
    task import_suppliers: :environment do
      DistributedLocks.distributed_lock(193) do
        ActiveRecord::Base.transaction do
          FacilitiesManagement::RM6232::Admin::FilesImporter.new.import_test_data
        rescue ActiveRecord::Rollback => e
          logger.error e.message
        end
      end
    end

    desc 'add Suppliers for RM6232 to the database'
    task static: :import_suppliers
  end

  desc 'add Suppliers for RM6232 to the database'
  task static: :'rm6232:import_suppliers'
end
