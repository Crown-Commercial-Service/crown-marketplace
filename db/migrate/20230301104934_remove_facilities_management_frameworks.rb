class RemoveFacilitiesManagementFrameworks < ActiveRecord::Migration[6.1]
  def change
    drop_table :facilities_management_frameworks, id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
      t.string :framework, limit: 6
      t.date :live_at
      t.timestamps
    end
  end
end
