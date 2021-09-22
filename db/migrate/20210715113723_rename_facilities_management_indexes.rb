class RenameFacilitiesManagementIndexes < ActiveRecord::Migration[6.0]
  INDEXES = [
    %i[facilities_management_management_reports index_facilities_management_management_reports_on_user_id index_fm_rm3830_management_reports_on_user_id user_id],
    %i[facilities_management_supplier_details index_facilities_management_supplier_details_on_contact_email index_fm_rm3830_supplier_details_on_contact_email contact_email],
    %i[facilities_management_supplier_details index_facilities_management_supplier_details_on_supplier_name index_fm_rm3830_supplier_details_on_supplier_name supplier_name],
    %i[facilities_management_supplier_details index_facilities_management_supplier_details_on_user_id index_fm_rm3830_supplier_details_on_user_id user_id]
  ].freeze

  def up
    INDEXES.each do |table_name, old_index, new_index, column|
      rename_index table_name, old_index, new_index if ActiveRecord::Base.connection.index_exists?(table_name, column, name: old_index)
    end
  end

  def down
    INDEXES.each do |table_name, old_index, new_index, column|
      rename_index table_name, new_index, old_index if ActiveRecord::Base.connection.index_exists?(table_name, column, name: new_index)
    end
  end
end
