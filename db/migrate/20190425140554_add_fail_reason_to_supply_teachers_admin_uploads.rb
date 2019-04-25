class AddFailReasonToSupplyTeachersAdminUploads < ActiveRecord::Migration[5.2]
  def change
    add_column :supply_teachers_admin_uploads, :fail_reason, :text
  end
end
