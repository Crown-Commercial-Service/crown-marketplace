namespace :further_competition do
  desc 'Update Further Competition data'
  task update_fc_data: :environment do
    DistributedLocks.distributed_lock(159) do
      p 'Started FC update'
      FacilitiesManagement::RakeModules::UpdateFCData.update_fc_data
      p 'Finished FC update'
    end
  end
end
