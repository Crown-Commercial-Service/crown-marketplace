module FacilitiesManagement
  class ChangeStateWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'fm', retry: true

    def perform(id)
      contract = FacilitiesManagement::RM3830::ProcurementSupplier.find(id)
      contract.expire! if contract.may_expire?
    end
  end
end
