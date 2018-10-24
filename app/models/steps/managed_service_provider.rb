module Steps
  class ManagedServiceProvider < JourneyStep
    attribute :managed_service_provider
    validates :managed_service_provider,
              inclusion: {
                in: ['master_vendor', 'neutral_vendor'],
                message: 'Please choose an option'
              }

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
