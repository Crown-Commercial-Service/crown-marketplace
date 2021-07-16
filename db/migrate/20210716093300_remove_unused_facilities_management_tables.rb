class RemoveUnusedFacilitiesManagementTables < ActiveRecord::Migration[6.0]
  # rubocop:disable Metrics/AbcSize
  def change
    remove_foreign_key 'facilities_management_regional_availabilities', 'facilities_management_suppliers'
    remove_foreign_key 'facilities_management_service_offerings', 'facilities_management_suppliers'

    drop_table 'facilities_management_uploads', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end

    drop_table 'fm_cache', id: false, force: :cascade do |t|
      t.text 'user_id', null: false
      t.text 'key', null: false
      t.text 'value'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['user_id', 'key'], name: 'fm_cache_user_id_idx'
    end

    drop_table 'facilities_management_suppliers', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
      t.text 'name', null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.text 'contact_name'
      t.text 'contact_email'
      t.text 'telephone_number'
    end

    drop_table 'facilities_management_regional_availabilities', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
      t.uuid 'facilities_management_supplier_id', null: false
      t.text 'lot_number', null: false
      t.text 'region_code', null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['facilities_management_supplier_id'], name: 'index_fm_regional_availabilities_on_fm_supplier_id'
      t.index ['lot_number', 'region_code', 'facilities_management_supplier_id'], name: 'index_regional_availabilities_on_lot_number_and_region_code', unique: true
      t.index ['lot_number'], name: 'index_fm_regional_availabilities_on_lot_number'
    end

    drop_table 'facilities_management_service_offerings', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
      t.uuid 'facilities_management_supplier_id', null: false
      t.text 'lot_number', null: false
      t.text 'service_code', null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['facilities_management_supplier_id'], name: 'index_fm_service_offerings_on_fm_supplier_id'
      t.index ['lot_number', 'service_code', 'facilities_management_supplier_id'], name: 'index_service_offerings_on_lot_number_and_service_code', unique: true
      t.index ['lot_number'], name: 'index_fm_service_offerings_on_lot_number'
    end
  end
  # rubocop:enable Metrics/AbcSize
end
