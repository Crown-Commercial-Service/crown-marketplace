module Steps
  class SchoolPostcode < JourneyStep
    attribute :postcode
    validates :postcode, postcode: true

    def next_step_class
      Results
    end
  end
end
