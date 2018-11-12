module TempToPermCalculator
  module Steps
    class SchoolHolidays
      include JourneyStep

      attribute :school_holidays

      def next_step_class
        Fee
      end
    end
  end
end
