module Steps
  class HireViaAgency < JourneyStep
    attribute :hire_via_agency
    validates :hire_via_agency, inclusion: { in: %w[yes no] }

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
