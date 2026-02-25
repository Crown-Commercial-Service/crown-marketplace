module FM::RM6378
  module Services
    def self.truncate_tables
      FacilitiesManagement::RM6378::Service.destroy_all
      FacilitiesManagement::RM6378::WorkPackage.destroy_all
    end

    def self.add_work_packages
      file_name = 'data/facilities_management/rm6378/work_packages.csv'

      CSV.read(file_name, headers: true).each do |row|
        FacilitiesManagement::RM6378::WorkPackage.create(row.to_h)
      end
    end

    def self.add_services
      file_name = 'data/facilities_management/rm6378/rm6378_service_specification.csv'

      CSV.read(file_name, headers: true).each do |row|
        FacilitiesManagement::RM6378::Service.create(row.to_h)
      end
    end
  end
end

namespace :db do
  namespace :rm6378 do
    desc 'Imports the services and work packages into the database'
    task import_services: :environment do
      # I changed the lock number to 192 so it doesn't collide with the old one
      DistributedLocks.distributed_lock(192) do
        ActiveRecord::Base.transaction do
          FM::RM6378::Services.truncate_tables
          FM::RM6378::Services.add_work_packages
          FM::RM6378::Services.add_services
        rescue ActiveRecord::Rollback => e
          logger.error e.message
        end
      end
    end
  end
end