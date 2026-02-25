module FacilitiesManagement
  module RM6378
    class Journey::ChooseServices
      include Steppable

      attribute :service_codes, :array, default: -> { [] }
      validates :service_codes, length: { minimum: 1 }
      validate :validate_not_all_mandatory

      attribute :region_codes, :array, default: -> { [] }
      attribute :annual_contract_value, :numeric
      attribute :contract_start_date_dd
      attribute :contract_start_date_mm
      attribute :contract_start_date_yyyy
      attribute :estimated_contract_duration, :numeric
      attribute :private_finance_initiative

      def next_step_class
        Journey::ChooseLocations
      end

      def services_grouped_by_category
        services = Service.where(lot_id: 'RM6378.1a').where.not(category: 'O').or(Service.where(lot_id: 'RM6378.4a'))

        category_names = services.pluck(:category).uniq

        services.order(Arel.sql('SUBSTRING(number FROM 2)::integer')).group_by(&:category).sort_by { |category_name, _services| category_names.index(category_name) }
      end

      private

      def validate_not_all_mandatory
        errors.add(:service_codes, :invalid_cafm_helpdesk) if (service_codes - MANDATORY_SERVICES).empty?
      end

      MANDATORY_SERVICES = %w[M2 N1].freeze
    end
  end
end
