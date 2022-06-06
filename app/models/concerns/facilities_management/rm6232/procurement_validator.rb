module FacilitiesManagement::RM6232
  module ProcurementValidator
    extend ActiveSupport::Concern

    included do
      validates :annual_contract_value, numericality: { only_integer: true, greater_than: 0, less_than: 1_000_000_000_000 }, on: :annual_contract_value

      # Validations on entering requirements
      with_options on: :entering_requirements do
        # TODO: Consider adding this
        # validate :all_buildings_have_regions
        validate :all_complete
      end
    end

    private

    def all_complete
      errors.add(:base, :incomplete)
    end
  end
end
