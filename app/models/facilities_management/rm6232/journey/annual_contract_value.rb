module FacilitiesManagement
  module RM6232
    class Journey::AnnualContractValue
      include Steppable

      attribute :annual_contract_value, :numeric

      validates :annual_contract_value, numericality: { only_integer: true, greater_than: 0, less_than: 1_000_000_000_000 }

      def next_step_class
        Journey::Procurement
      end
    end
  end
end
