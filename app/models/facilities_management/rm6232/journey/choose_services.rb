module FacilitiesManagement
  module RM6232
    class Journey::ChooseServices
      include Steppable

      attribute :service_codes, Array
      attribute :region_codes, Array
      attribute :sector_code, String
      attribute :contract_cost, Numeric

      validates :service_codes, length: { minimum: 1 }
      validate :validate_cleaning_selection, :validate_not_all_mandatory, :validate_cafm

      def work_packages
        WorkPackage.selectable
      end

      def next_step_class
        Journey::ChooseLocations
      end

      private

      def validate_cleaning_selection
        errors.add(:service_codes, :invalid_cleaning) if service_codes.include?('I.1') && service_codes.include?('I.4')
      end

      def validate_not_all_mandatory
        errors.add(:service_codes, :invalid_cafm_helpdesk_billable) if (service_codes - MANDATORY_SERVICES).empty?
      end

      def validate_cafm
        return unless service_codes.include? 'P.1'

        if service_codes.include?('P.1') && service_codes.include?('P.2')
          errors.add(:service_codes, :invalid_multiple_cafm)
        elsif Service.determine_lot_number(service_codes - ['P.1']) != '3'
          errors.add(:service_codes, :invalid_cafm) unless (service_codes - (MANDATORY_SERVICES + LANDSCAPING_SERVICES)).empty?
        end
      end

      MANDATORY_SERVICES = %w[P.1 P.2 Q.1 R.1].freeze
      LANDSCAPING_SERVICES = %w[G.1 G.2 G.3 G.4 G.5 G.6 G.7 G.8].freeze
    end
  end
end
