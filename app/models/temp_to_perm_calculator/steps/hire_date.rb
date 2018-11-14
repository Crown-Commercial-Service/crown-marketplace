module TempToPermCalculator
  module Steps
    class HireDate
      include JourneyStep

      attribute :hire_date_day
      validates :hire_date_day,
                presence: true,
                numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 31 }
      attribute :hire_date_month
      validates :hire_date_month,
                presence: true,
                numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }

      attribute :hire_date_year
      validates :hire_date_year,
                presence: true,
                numericality: { only_integer: true }

      def next_step_class
        DaysPerWeek
      end
    end
  end
end
