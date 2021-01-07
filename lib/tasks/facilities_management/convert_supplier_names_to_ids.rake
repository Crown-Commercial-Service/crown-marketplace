namespace :fm_supplier do
  desc 'Convert the supplier names to ids'
  task convert_name_to_ids: :environment do
    DistributedLocks.distributed_lock(155) do
      p 'Starting the conversion of supplier names to ids'
      FacilitiesManagement::RakeModules::ConvertSupplierNames.new(:supplier_name_to_id).complete_task
    end
  end

  desc 'Convert the ids to supplier names'
  task convert_ids_to_names: :environment do
    DistributedLocks.distributed_lock(155) do
      p 'Starting the conversion of ids to supplier names'
      FacilitiesManagement::RakeModules::ConvertSupplierNames.new(:id_to_supplier_name).complete_task
    end
  end
end
