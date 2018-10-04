class CreateBranches < ActiveRecord::Migration[5.2]
  def change
    create_table :branches, id: :uuid do |t|
      t.references :supplier, foreign_key: true, type: :uuid, null: false
      t.string :postcode, limit: 8, null: false
      t.timestamps
    end
  end
end
