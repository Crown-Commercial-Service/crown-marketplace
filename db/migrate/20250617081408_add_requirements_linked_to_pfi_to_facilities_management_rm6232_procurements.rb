class AddRequirementsLinkedToPfiToFacilitiesManagementRM6232Procurements < ActiveRecord::Migration[8.0]
  def change
    add_column :facilities_management_rm6232_procurements, :requirements_linked_to_pfi, :boolean
  end
end
