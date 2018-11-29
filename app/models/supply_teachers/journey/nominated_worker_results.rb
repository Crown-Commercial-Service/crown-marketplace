module SupplyTeachers
  class Journey::NominatedWorkerResults
    include JourneyStep
    include Journey::Results
    include ActiveSupport::NumberHelper

    def rates
      Rate.direct_provision.nominated_worker
    end

    def rate(branch)
      branch.supplier.nominated_worker_rate
    end

    def inputs
      {
        looking_for: translate_input('supply_teachers.looking_for.worker'),
        worker_type: translate_input('supply_teachers.worker_type.nominated'),
        postcode: postcode,
        radius: number_to_human(radius, units: :miles)
      }
    end
  end
end
