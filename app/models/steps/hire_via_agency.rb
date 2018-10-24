module Steps
  class HireViaAgency < JourneyStep
    attribute :looking_for
    validates :looking_for,
              inclusion: {
                in: ['worker', 'managed_service_provider'],
                message: 'Please choose an option'
              }

    def next_step_class
      case looking_for
      when 'worker'
        NominatedWorker
      when 'managed_service_provider'
        ManagedServiceProvider
      end
    end
  end
end
