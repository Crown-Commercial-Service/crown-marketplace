class RemoveCutModels < ActiveRecord::Migration[7.0]
  # rubocop:disable Metrics/AbcSize
  def change
    drop_table 'facilities_management_rm6232_procurement_buildings', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
      t.uuid 'facilities_management_rm6232_procurement_id'
      t.uuid 'building_id'
      t.boolean 'active'
      t.text 'service_codes', default: [], array: true
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.jsonb 'frozen_building_data', default: {}
      t.index ['active'], name: 'index_fm_rm6232_procurement_buildings_on_active'
      t.index ['building_id'], name: 'index_building_on_fm_rm6232_procurements_id'
      t.index ['facilities_management_rm6232_procurement_id'], name: 'index_procurement_building_on_fm_rm6232_procurements_id'
    end

    drop_table 'facilities_management_rm6232_procurement_call_off_extensions', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
      t.uuid 'facilities_management_rm6232_procurement_id'
      t.integer 'extension'
      t.integer 'years'
      t.integer 'months'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['facilities_management_rm6232_procurement_id'], name: 'index_optional_call_off_on_fm_rm6232_procurements_id'
    end

    remove_column :facilities_management_rm6232_procurements, :aasm_state,                      :string, limit: 30
    remove_column :facilities_management_rm6232_procurements, :tupe,                            :boolean
    remove_column :facilities_management_rm6232_procurements, :initial_call_off_period_years,   :integer
    remove_column :facilities_management_rm6232_procurements, :initial_call_off_period_months,  :integer
    remove_column :facilities_management_rm6232_procurements, :initial_call_off_start_date,     :date
    remove_column :facilities_management_rm6232_procurements, :mobilisation_period_required,    :boolean
    remove_column :facilities_management_rm6232_procurements, :mobilisation_period,             :integer
    remove_column :facilities_management_rm6232_procurements, :extensions_required,             :boolean
  end
  # rubocop:enable Metrics/AbcSize
end
