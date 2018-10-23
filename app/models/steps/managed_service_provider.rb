module Steps
  class ManagedServiceProvider < JourneyStep
    attribute :master_vendor
    validates :master_vendor, yes_no: true

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
