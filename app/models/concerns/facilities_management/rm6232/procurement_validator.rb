module FacilitiesManagement::RM6232
  module ProcurementValidator
    extend ActiveSupport::Concern

    included do
      validates :annual_contract_value, numericality: { only_integer: true, greater_than: 0, less_than: 1_000_000_000_000 }, on: :annual_contract_value

      # Validations on entering requirements
      with_options on: :entering_requirements do
        validate :all_buildings_have_regions
        validate :all_complete, on: :entering_requirements
      end
    end

    private

    def all_complete
      check_contract_details_completed
      check_contract_period_completed
      check_service_and_buildings_present
      check_service_and_buildings_completed
    end

    def check_contract_details_completed
      errors.add(:base, :tupe_incomplete) unless tupe_status == :completed
    end

    def check_service_and_buildings_completed
      errors.add(:base, :buildings_and_services_incomplete) if error_list.intersect?(%i[services_incomplete buildings_incomplete]) || !buildings_and_services_completed?
    end
  end
end
