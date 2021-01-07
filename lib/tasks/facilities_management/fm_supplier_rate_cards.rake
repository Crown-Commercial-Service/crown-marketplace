namespace :db do
  desc 'uploading supplier rates cards'
  task fmcards: :environment do
    p '**** Loading FM Supplier rates cards'
    DistributedLocks.distributed_lock(154) do
      FacilitiesManagement::RakeModules::SupplierRateCards.add_rate_cards_to_suppliers
    end
  end

  desc 'add static data to the database'
  task static: :fmcards do
  end
end
