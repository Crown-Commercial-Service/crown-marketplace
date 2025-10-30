module FacilitiesManagement
  module RM6378
    class Journey::ChooseServices
      include Steppable

      attribute :service_codes, Array
      validates :service_codes, length: { minimum: 1 }
      validate :validate_not_all_mandatory

      attribute :region_codes, Array
      attribute :annual_contract_value, Numeric

      def next_step_class
        Journey::ChooseLocations
      end

      def services_grouped_by_category
        services = Service.where(lot_id: 'RM6378.1a').where.not(category: 'S').or(Service.where(lot_id: 'RM6378.4a'))

        category_names = services.pluck(:category).uniq

        services.order(Arel.sql('SUBSTRING(number FROM 2)::integer')).group_by(&:category).sort_by { |category_name, _services| category_names.index(category_name) }
      end

      private

      def validate_not_all_mandatory
        errors.add(:service_codes, :invalid_cafm_helpdesk) if (service_codes - MANDATORY_SERVICES).empty?
      end

      MANDATORY_SERVICES = %w[Q2 R1].freeze
    end
  end
end
