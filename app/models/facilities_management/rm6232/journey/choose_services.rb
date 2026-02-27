module FacilitiesManagement
  module RM6232
    class Journey::ChooseServices
      include Steppable

      attribute :service_codes, :array, default: -> { [] }
      validates :service_codes, length: { minimum: 1 }
      validate :validate_not_all_mandatory

      attribute :region_codes, :array, default: -> { [] }
      attribute :annual_contract_value, :numeric

      def next_step_class
        Journey::ChooseLocations
      end

      private

      def validate_not_all_mandatory
        errors.add(:service_codes, :invalid_cafm_helpdesk_billable) if (service_codes - MANDATORY_SERVICES).empty?
      end

      MANDATORY_SERVICES = %w[Q.3 R.1 S.1].freeze
    end
  end
end
