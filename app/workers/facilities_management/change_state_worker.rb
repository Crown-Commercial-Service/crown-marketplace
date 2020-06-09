module FacilitiesManagement
  class ChangeStateWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'fm', retry: true

    def perform(id)
      contract = FacilitiesManagement::ProcurementSupplier.find(id)
      begin
        contract.expire! if contract.may_expire?
      rescue NoMethodError => e
        Sidekiq.logger('Change state worker error:')
        Sidekiq.logger(e.to_s)
      end
    end
  end
end
