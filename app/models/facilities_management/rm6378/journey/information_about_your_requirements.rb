module FacilitiesManagement
  module RM6378
    class Journey::InformationAboutYourRequirements
      DATE_ATTIBUTES = %i[contract_start_date].freeze

      include Steppable
      include DateValidations

      PFI_OPTIONS = %w[yes no].freeze

      attribute :contract_start_date_dd
      attribute :contract_start_date_mm
      attribute :contract_start_date_yyyy
      attribute :estimated_contract_duration, :numeric
      attribute :private_finance_initiative

      validates :contract_start_date, presence: true
      validate  -> { ensure_date_valid(:contract_start_date, false) }
      validate  -> { ensure_date_is_after(contract_start_date, DateTime.now.in_time_zone('London'), :contract_start_date, :date_in_future) }

      validates :estimated_contract_duration, numericality: { only_integer: true, greater_than: 0, less_than: 100 }
      validates :private_finance_initiative, inclusion: PFI_OPTIONS

      def next_step_class
        Journey::Procurement
      end
    end
  end
end
