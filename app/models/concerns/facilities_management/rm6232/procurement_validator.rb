module FacilitiesManagement::RM6232
  module ProcurementValidator
    extend ActiveSupport::Concern

    included do
      with_options on: :contract_name do
        before_validation :remove_excess_whitespace_from_name
        validates :contract_name, presence: true
        validates :contract_name, uniqueness: { scope: :user }
        validates :contract_name, length: 1..100
      end

      validates :annual_contract_value, numericality: { only_integer: true, greater_than: 0, less_than: 1_000_000_000_000 }, on: :annual_contract_value

      validates :tupe, inclusion: [true, false], on: :tupe

      # Validations on entering requirements
      with_options on: :entering_requirements do
        # TODO: Consider adding this
        # validate :all_buildings_have_regions
        validate :all_complete
      end
    end

    private

    def remove_excess_whitespace_from_name
      contract_name&.squish!
    end

    def all_complete
      errors.add(:base, :incomplete)
    end
  end
end
