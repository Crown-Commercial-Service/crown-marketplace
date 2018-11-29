module SupplyTeachers
  class Journey::LookingFor
    include JourneyStep

    attribute :looking_for
    validates :looking_for, inclusion: ['worker', 'managed_service_provider']

    def next_step_class
      case looking_for
      when 'worker'
        Journey::WorkerType
      when 'managed_service_provider'
        Journey::ManagedServiceProvider
      end
    end
  end
end
