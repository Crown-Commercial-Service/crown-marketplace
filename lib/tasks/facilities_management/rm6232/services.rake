module FM::RM6232
  module Services
    def self.truncate_tables
      FacilitiesManagement::RM6232::Service.destroy_all
      FacilitiesManagement::RM6232::WorkPackage.destroy_all
    end

    def self.add_work_packages
      file_name = 'data/facilities_management/rm6232/work_packages.csv'

      CSV.read(file_name, headers: true).each do |row|
        FacilitiesManagement::RM6232::WorkPackage.create(row.to_h)
      end
    end

    def self.add_services
      file_name = 'data/facilities_management/rm6232/services.csv'

      CSV.read(file_name, headers: true).each do |row|
        FacilitiesManagement::RM6232::Service.create(row.to_h)
      end
    end
  end
end

namespace :db do
  namespace :rm6232 do
    desc 'Imports the services and work packages into the database'
    task import_services: :environment do
      DistributedLocks.distributed_lock(191) do
        ActiveRecord::Base.transaction do
          FM::RM6232::Services.truncate_tables
          FM::RM6232::Services.add_work_packages
          FM::RM6232::Services.add_services
        rescue ActiveRecord::Rollback => e
          logger.error e.message
        end
      end
    end

    desc 'add Services for RM6232 to the database'
    task static: :import_services
  end

  desc 'add Services for RM6232 to the database'
  task static: :'rm6232:import_services'
end
