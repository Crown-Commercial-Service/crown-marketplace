module SupplyTeachers
  module Steps
    class NominatedWorkerResults
      include JourneyStep
      include Results

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
          postcode: postcode
        }
      end
    end
  end
end
