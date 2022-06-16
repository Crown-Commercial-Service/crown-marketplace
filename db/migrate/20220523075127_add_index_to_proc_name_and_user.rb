class AddIndexToProcNameAndUser < ActiveRecord::Migration[6.0]
  def change
    add_index :facilities_management_rm6232_procurements, %i[user_id contract_name], unique: true, name: 'index_rm6232_procurement_name_and_user_id'
  end
end
