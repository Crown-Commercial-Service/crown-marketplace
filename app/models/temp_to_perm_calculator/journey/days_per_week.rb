module TempToPermCalculator
  class Journey::DaysPerWeek
    include ::Journey::Step

    attribute :days_per_week
    validates :days_per_week, presence: true, numericality: { only_integer: true }

    def next_step_class
      Journey::DayRate
    end
  end
end
