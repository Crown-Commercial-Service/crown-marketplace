namespace :db do
  namespace :rm3830 do
    desc 'add the Supplier data into the database'
    task fm_supplier_data: :environment do
      p 'Loading FM Suppliers static'
      DistributedLocks.distributed_lock(152) do
        FacilitiesManagement::RM3830::SupplierDetail.destroy_all
        FacilitiesManagement::RakeModules::SupplierData.fm_suppliers
        FacilitiesManagement::RakeModules::SupplierData.fm_supplier_contact_details
      end
    end

    task add_supplier_rate_cards: :environment do
      p '**** Loading FM Supplier rates cards'
      DistributedLocks.distributed_lock(154) do
        FacilitiesManagement::RM3830::Admin::FilesImporter.new.import_test_data
      end
    end
  end

  desc 'add static data to the database'
  task static: %i[rm3830:fm_supplier_data rm3830:add_supplier_rate_cards]
end
