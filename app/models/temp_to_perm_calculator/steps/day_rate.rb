module TempToPermCalculator
  module Steps
    class DayRate
      include JourneyStep

      attribute :day_rate

      def next_step_class
        MarkupRate
      end
    end
  end
end
