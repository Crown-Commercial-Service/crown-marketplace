module SupplyTeachers
  class Journey::LookingFor
    include Steppable

    attribute :looking_for
    validates :looking_for, inclusion: %w[
      worker
      managed_service_provider
      calculate_temp_to_perm_fee
      calculate_fta_to_perm_fee
      all_suppliers
    ]

    def next_step_class
      case looking_for
      when 'worker'
        Journey::WorkerType
      when 'managed_service_provider'
        Journey::ManagedServiceProvider
      when 'calculate_temp_to_perm_fee'
        Journey::TempToPermCalculator
      when 'calculate_fta_to_perm_fee'
        Journey::FTAToPermCalculator
      when 'all_suppliers'
        Journey::AllSuppliers
      end
    end
  end
end
