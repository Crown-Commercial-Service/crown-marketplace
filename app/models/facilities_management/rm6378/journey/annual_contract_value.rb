module FacilitiesManagement
  module RM6378
    class Journey::AnnualContractValue
      include Steppable

      attribute :annual_contract_value, Numeric

      attribute :contract_start_date_dd
      attribute :contract_start_date_mm
      attribute :contract_start_date_yyyy
      attribute :estimated_contract_duration, Numeric
      attribute :private_finance_initiative

      validates :annual_contract_value, numericality: { only_integer: true, greater_than: 0, less_than: 1_000_000_000_000 }

      def next_step_class
        Journey::InformationAboutYourRequirements
      end
    end
  end
end
