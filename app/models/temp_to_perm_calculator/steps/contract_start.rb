module TempToPermCalculator
  module Steps
    class ContractStart
      include JourneyStep

      attribute :contract_start_day
      attribute :contract_start_month
      attribute :contract_start_year

      def next_step_class
        HireDate
      end
    end
  end
end
