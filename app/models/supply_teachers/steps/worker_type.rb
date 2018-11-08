module SupplyTeachers::Steps
  class WorkerType
    include JourneyStep

    attribute :worker_type
    validates :worker_type, inclusion: ['nominated', 'agency_supplied']

    def next_step_class
      case worker_type
      when 'nominated'
        SchoolPostcode
      when 'agency_supplied'
        PayrollProvider
      end
    end
  end
end
