namespace :db do
  desc 'download from aws'
  task aws: :environment do
    p 'Loading FM Suppliers static'
    DistributedLocks.distributed_lock(152) do
      FacilitiesManagement::SupplierDetail.destroy_all
      FacilitiesManagement::RakeModules::SupplierData.fm_suppliers
      FacilitiesManagement::RakeModules::SupplierData.fm_supplier_contact_details
    end
  end

  desc 'add static data to the database'
  task static: :aws do
  end
end
