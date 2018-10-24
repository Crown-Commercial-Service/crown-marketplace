module Steps
  class NominatedWorker < JourneyStep
    attribute :worker_type
    validates :worker_type,
              inclusion: {
                in: ['nominated', 'agency_supplied'],
                message: 'Please choose an option'
              }

    def next_step_class
      case worker_type
      when 'nominated'
        SchoolPostcode
      when 'agency_supplied'
        SchoolPayroll
      end
    end
  end
end
