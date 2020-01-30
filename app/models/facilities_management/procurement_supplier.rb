module FacilitiesManagement
  class ProcurementSupplier < ApplicationRecord
    default_scope { order(direct_award_value: :asc) }
    belongs_to :procurement, class_name: 'FacilitiesManagement::Procurement', foreign_key: :facilities_management_procurement_id, inverse_of: :procurement_suppliers

    def self.used_direct_award_contract_numbers_for_current_year
      where('contract_number like ?', 'RM3860-DA%')
        .where('contract_number like ?', "%-#{Date.current.year}")
        .pluck(:contract_number)
        .map { |contract_number| contract_number.split('-')[1].split('DA')[1] }
    end

    def self.used_further_competition_contract_numbers_for_current_year
      where('contract_number like ?', 'RM3860-FC%')
        .where('contract_number like ?', "%-#{Date.current.year}")
        .pluck(:contract_number)
        .map { |contract_number| contract_number.split('-')[1].split('FC')[1] }
    end

    def supplier
      CCS::FM::Supplier.find(supplier_id)
    end

    private

    def generate_contract_number
      return unless procurement.further_competition? || procurement.direct_award?

      return ContractNumberGenerator.new(procurement_state: :direct_award, used_numbers: self.class.used_direct_award_contract_numbers_for_current_year).new_number if procurement.direct_award?

      ContractNumberGenerator.new(procurement_state: :further_competition, used_numbers: self.class.used_further_competition_contract_numbers_for_current_year).new_number
    end
  end
end
