module SupplyTeachers
  class Journey::ManagedServiceProvider
    include JourneyStep

    attribute :managed_service_provider
    validates :managed_service_provider, inclusion: ['master_vendor', 'neutral_vendor']

    def next_step_class
      case managed_service_provider
      when 'master_vendor'
        Journey::MasterVendorManagedService
      when 'neutral_vendor'
        Journey::NeutralVendorManagedService
      end
    end
  end
end
