class CreateFmFrozenRateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :fm_frozen_rate_cards, id: :uuid do |t|
      t.references :facilities_management_procurement,
                   foreign_key: true, type: :uuid, null: false,
                   index: { name: 'index_frozen_fm_rate_cards_procurement' }
      t.jsonb :data

      t.text :source_file, null: false

      t.timestamps

      t.index ['data'], name: 'idx_fm_frozen_rate_cards_gin', using: :gin
      t.index ['data'], name: 'idx_fm_frozen_rate_cards_ginp', opclass: :jsonb_path_ops, using: :gin
    end
  end
end
