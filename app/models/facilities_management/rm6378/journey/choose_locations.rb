module FacilitiesManagement
  module RM6378
    class Journey::ChooseLocations
      include Steppable

      attribute :region_codes, Array
      validates :region_codes, length: { minimum: 1 }

      attribute :annual_contract_value, Numeric
      attribute :contract_start_date_dd
      attribute :contract_start_date_mm
      attribute :contract_start_date_yyyy
      attribute :estimated_contract_duration, Numeric
      attribute :private_finance_initiative

      def next_step_class
        Journey::AnnualContractValue
      end

      def regions_grouped_by_category
        jurisdictions = Jurisdiction.where.not(category: %i[core non-core])

        category_names = jurisdictions.pluck(:category).uniq

        jurisdictions.order(Arel.sql('LENGTH(id)'), Arel.sql('SUBSTRING(id FROM 4)')).group_by(&:category).sort_by { |category_name, _jurisdictions| category_names.index(category_name) }
      end
    end
  end
end
