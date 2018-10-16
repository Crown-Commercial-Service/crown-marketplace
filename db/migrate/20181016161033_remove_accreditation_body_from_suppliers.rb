class RemoveAccreditationBodyFromSuppliers < ActiveRecord::Migration[5.2]
  def change
    remove_column :suppliers, :accreditation_body, :text
  end
end
