module SupplyTeachers
  class Journey::LookingFor
    include ::Journey::Step

    attribute :looking_for
    validates :looking_for, inclusion: %w[
      worker
      managed_service_provider
      calculate_temp_to_perm_fee
    ]

    def next_step_class
      case looking_for
      when 'worker'
        Journey::WorkerType
      when 'managed_service_provider'
        Journey::ManagedServiceProvider
      when 'calculate_temp_to_perm_fee'
        Journey::ContractStart
      end
    end
  end
end
