module FacilitiesManagement
  module RM6232
    class Journey::ChooseLocations
      include Steppable

      attribute :region_codes, :array, default: -> { [] }
      validates :region_codes, length: { minimum: 1 }

      attribute :annual_contract_value, :numeric

      def next_step_class
        Journey::AnnualContractValue
      end
    end
  end
end
