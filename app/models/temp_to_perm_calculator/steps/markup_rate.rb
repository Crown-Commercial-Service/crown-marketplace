module TempToPermCalculator
  module Steps
    class MarkupRate
      include JourneyStep

      attribute :markup_rate

      def next_step_class
        SchoolHolidays
      end
    end
  end
end
