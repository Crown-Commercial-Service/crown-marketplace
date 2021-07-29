module FacilitiesManagement
  module RM6232
    class Journey::ContractCost
      include Steppable

      attribute :contract_cost, Numeric

      validates :contract_cost, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 999999999 }

      def next_step_class
        Journey::Procurement
      end
    end
  end
end
