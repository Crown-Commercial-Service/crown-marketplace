module TempToPermCalculator
  module Steps
    class HireDate
      include JourneyStep

      attribute :hire_date_day
      attribute :hire_date_month
      attribute :hire_date_year

      def next_step_class
        DaysPerWeek
      end
    end
  end
end
