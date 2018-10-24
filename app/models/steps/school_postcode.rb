module Steps
  class SchoolPostcode < JourneyStep
    attribute :nominated_worker
    attribute :postcode
    validates :postcode, postcode: true

    def next_step_class
      if nominated_worker == 'yes'
        NominatedWorkerResults
      else
        FixedTermResults
      end
    end
  end
end
