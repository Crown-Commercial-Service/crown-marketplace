module Steps
  class AgencyPayroll < JourneyStep
    attribute :postcode
    validates :postcode, postcode: true

    attribute :term
    validates :term, presence: true

    attribute :job_type
    validates :job_type, presence: true

    def next_step_class
      Results
    end
  end
end
