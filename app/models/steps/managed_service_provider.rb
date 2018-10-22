module Steps
  class ManagedServiceProvider < JourneyStep
    attribute :master_vendor
    validates :master_vendor, inclusion: { in: %w[yes no] }

    def next_step_class
      case master_vendor
      when 'yes'
        MasterVendorManagedService
      when 'no'
        NeutralVendorManagedService
      end
    end
  end
end
