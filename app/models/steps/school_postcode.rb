module Steps
  class SchoolPostcode < JourneyStep
    attribute :postcode
    validates :postcode, presence: true

    def next_step_class
      Results
    end
  end
end
