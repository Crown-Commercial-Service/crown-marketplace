module FacilitiesManagement
  module RM6232
    class Journey::ChooseSector
      include Steppable

      attribute :sector_code, String
      attribute :contract_cost, Numeric

      validates :sector_code, presence: true

      def sectors
        Sector.all.order(:name)
      end

      def next_step_class
        Journey::ContractCost
      end
    end
  end
end
