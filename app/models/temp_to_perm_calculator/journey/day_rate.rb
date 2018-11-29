module TempToPermCalculator
  class Journey::DayRate
    include ::Journey::Step

    attribute :day_rate
    validates :day_rate, presence: true, numericality: { only_integer: true }

    def next_step_class
      Journey::MarkupRate
    end
  end
end
