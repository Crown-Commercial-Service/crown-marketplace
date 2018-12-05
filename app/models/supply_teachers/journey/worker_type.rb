module SupplyTeachers
  class Journey::WorkerType
    include Steppable

    attribute :worker_type
    validates :worker_type, inclusion: ['nominated', 'agency_supplied']

    def next_step_class
      case worker_type
      when 'nominated'
        Journey::SchoolPostcodeNominatedWorker
      when 'agency_supplied'
        Journey::PayrollProvider
      end
    end
  end
end
