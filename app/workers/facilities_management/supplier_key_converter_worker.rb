module FacilitiesManagement
  class SupplierKeyConverterWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'fm'

    def perform(list)
      FacilitiesManagement::RakeModules::ConvertSupplierNames.new(list.to_sym).complete_task
    end
  end
end
