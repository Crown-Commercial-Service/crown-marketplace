class AddIndexOnSearchedValues < ActiveRecord::Migration[6.0]
  def change
    add_index :facilities_management_rm6232_procurements, 'lower(contract_name)', using: :btree, name: 'index_fm_rm6232_procurements_on_lower_contract_name'
    add_index :facilities_management_rm6232_procurements, 'lower(contract_number)', using: :btree, name: 'index_fm_rm6232_procurements_on_lower_contract_number'
  end
end
