class CreateFacilitiesManagementFrameworkTable < ActiveRecord::Migration[6.0]
  def change
    create_table :facilities_management_frameworks, id: :uuid do |t|
      t.string :framework, limit: 6
      t.date :live_at

      t.timestamps
    end
  end
end
