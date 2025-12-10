module FacilitiesManagement
  module RM6378
    class Journey::InformationAboutYourRequirements
      include Steppable

      attribute :estimated_contract_duration, Numeric

      validates :estimated_contract_duration, numericality: { only_integer: true, greater_than: 0, less_than: 100 }


      PFI_OPTIONS = %w[yes no].freeze

      attribute :private_finance_initiative
      validates :private_finance_initiative, inclusion: PFI_OPTIONS


      def next_step_class
        Journey::Procurement
      end
    end
  end
end