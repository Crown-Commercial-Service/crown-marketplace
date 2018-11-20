module TempToPermCalculator
  module Steps
    class MarkupRate
      include JourneyStep

      attribute :markup_rate
      validates :markup_rate,
                presence: true,
                numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

      def next_step_class
        Fee
      end
    end
  end
end
