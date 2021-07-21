namespace :db do
  desc 'uploading supplier rates cards'
  task add_fmcards: :environment do
    p '**** Loading FM Supplier rates cards'
    DistributedLocks.distributed_lock(154) do
      FacilitiesManagement::RM3830::Admin::SupplierFrameworkDataImporter.new.import_test_data
    end
  end
end
