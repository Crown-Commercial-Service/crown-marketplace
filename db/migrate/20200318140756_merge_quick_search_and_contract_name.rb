class MergeQuickSearchAndContractName < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/SkipsModelValidations
  def change
    FacilitiesManagement::Procurement.where(contract_name: nil).update_all('contract_name=name')
  end
  # rubocop:enable Rails/SkipsModelValidations
end
