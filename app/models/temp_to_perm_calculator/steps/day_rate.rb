module TempToPermCalculator
  module Steps
    class DayRate
      include JourneyStep

      attribute :day_rate
      validates :day_rate, presence: true, numericality: { only_integer: true }

      def next_step_class
        MarkupRate
      end
    end
  end
end
