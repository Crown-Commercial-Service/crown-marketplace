module Steps
  class HireViaAgency < JourneyStep
    attribute :hire_via_agency
    validates :hire_via_agency, yes_no: true

    def next_step_class
      case hire_via_agency
      when 'yes'
        NominatedWorker
      when 'no'
        ManagedServiceProvider
      end
    end
  end
end
