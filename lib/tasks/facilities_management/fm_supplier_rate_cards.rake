namespace :db do
  desc 'uploading supplier rates cards'
  task add_fmcards: :environment do
    p '**** Loading FM Supplier rates cards'
    DistributedLocks.distributed_lock(154) do
      FacilitiesManagement::RakeModules::SupplierRateCards.import_rate_cards_for_suppliers(:add)
    end
  end

  task update_fmcards: :environment do
    p '**** Updating FM Supplier rates cards'
    DistributedLocks.distributed_lock(155) do
      FacilitiesManagement::RakeModules::SupplierRateCards.import_rate_cards_for_suppliers(:update)
    end
  end
end
