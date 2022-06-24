module FacilitiesManagement
  module RM6232
    class Journey::StartASearch
      include Steppable

      attribute :service_codes, Array
      attribute :region_codes, Array
      attribute :annual_contract_value, Numeric

      def next_step_class
        Journey::ChooseServices
      end
    end
  end
end
