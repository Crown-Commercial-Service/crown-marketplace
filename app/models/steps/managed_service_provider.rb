module Steps
  class ManagedServiceProvider
    include JourneyStep

    attribute :managed_service_provider
    validates :managed_service_provider, inclusion: ['master_vendor', 'neutral_vendor']

    def next_step_class
      case managed_service_provider
      when 'master_vendor'
        MasterVendorManagedService
      when 'neutral_vendor'
        NeutralVendorManagedService
      end
    end
  end
end
