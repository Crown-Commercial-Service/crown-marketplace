namespace :fm_supplier do
  desc 'Convert the supplier names to ids'
  task convert_name_to_ids: :environment do
    DistributedLocks.distributed_lock(155) do
      p 'Starting the conversion of supplier names to ids in background'
      FacilitiesManagement::SupplierKeyConverterWorker.perform_async(:supplier_name_to_id)
    end
  end

  desc 'Convert the ids to supplier names'
  task convert_ids_to_names: :environment do
    DistributedLocks.distributed_lock(155) do
      p 'Starting the conversion of ids to supplier names in background'
      FacilitiesManagement::SupplierKeyConverterWorker.perform_async(:id_to_supplier_name)
    end
  end
end
