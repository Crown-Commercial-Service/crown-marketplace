module TempToPermCalculator
  module Steps
    class DaysPerWeek
      include JourneyStep

      attribute :days_per_week

      def next_step_class
        DayRate
      end
    end
  end
end
