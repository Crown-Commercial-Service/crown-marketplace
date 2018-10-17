# rubocop:disable Migration/RequireLimitOnString
class AddSupplierRates < ActiveRecord::Migration[5.2]
  def change
    create_table :rates, id: :uuid do |t|
      t.references :supplier, foreign_key: true, type: :uuid, null: false
      t.string :job_type, null: false
      t.float :mark_up, null: false
      t.timestamps
    end
  end
end
# rubocop:enable Migration/RequireLimitOnString
