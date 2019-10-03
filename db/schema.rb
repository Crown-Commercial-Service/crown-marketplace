# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_01_122201) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "facilities_management_buildings", id: :uuid, default: nil, force: :cascade do |t|
    t.string "user_id", null: false
    t.jsonb "building_json", null: false
    t.datetime "updated_at", default: "2019-08-19 12:00:37", null: false
    t.string "status", default: "Incomplete", null: false
    t.string "updated_by", null: false
    t.index "((building_json -> 'services'::text))", name: "idx_buildings_service", using: :gin
    t.index ["building_json"], name: "idx_buildings_gin", using: :gin
    t.index ["building_json"], name: "idx_buildings_ginp", opclass: :jsonb_path_ops, using: :gin
    t.index ["id"], name: "index_facilities_management_buildings_on_id", unique: true
    t.index ["user_id"], name: "idx_buildings_user_id"
  end

  create_table "facilities_management_procurements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "name", limit: 100
    t.string "aasm_state", limit: 15
    t.string "updated_by", limit: 100
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "contract_name", limit: 100
    t.integer "estimated_annual_cost"
    t.boolean "tupe"
    t.integer "initial_call_off_period"
    t.date "initial_call_off_start_date"
    t.date "initial_call_off_end_date"
    t.integer "mobilisation_period"
    t.integer "optional_call_off_extensions_1"
    t.integer "optional_call_off_extensions_2"
    t.integer "optional_call_off_extensions_3"
    t.integer "optional_call_off_extensions_4"
    t.text "service_codes", default: [], array: true
    t.text "region_codes", default: [], array: true
    t.boolean "estimated_cost_known"
    t.index ["user_id"], name: "index_facilities_management_procurements_on_user_id"
  end

  create_table "facilities_management_regional_availabilities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "facilities_management_supplier_id", null: false
    t.text "lot_number", null: false
    t.text "region_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facilities_management_supplier_id"], name: "index_fm_regional_availabilities_on_fm_supplier_id"
    t.index ["lot_number"], name: "index_fm_regional_availabilities_on_lot_number"
  end

  create_table "facilities_management_service_offerings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "facilities_management_supplier_id", null: false
    t.text "lot_number", null: false
    t.text "service_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facilities_management_supplier_id"], name: "index_fm_service_offerings_on_fm_supplier_id"
    t.index ["lot_number"], name: "index_fm_service_offerings_on_lot_number"
  end

  create_table "facilities_management_suppliers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "contact_name"
    t.text "contact_email"
    t.text "telephone_number"
  end

  create_table "facilities_management_uploads", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fm_cache", id: false, force: :cascade do |t|
    t.string "user_id", null: false
    t.string "key", null: false
    t.string "value"
    t.index ["user_id", "key"], name: "fm_cache_user_id_idx"
  end

  create_table "fm_lifts", id: false, force: :cascade do |t|
    t.string "user_id", null: false
    t.string "building_id", null: false
    t.jsonb "lift_data", null: false
    t.index "((lift_data -> 'floor-data'::text))", name: "fm_lifts_lift_json", using: :gin
    t.index ["user_id", "building_id"], name: "fm_lifts_user_id_idx"
  end

  create_table "fm_rate_cards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "data"
    t.text "source_file", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["data"], name: "idx_fm_rate_cards_gin", using: :gin
    t.index ["data"], name: "idx_fm_rate_cards_ginp", opclass: :jsonb_path_ops, using: :gin
  end

  create_table "fm_rates", id: false, force: :cascade do |t|
    t.string "code", limit: 255
    t.decimal "framework"
    t.decimal "benchmark"
    t.index ["code"], name: "fm_rates_code_key", unique: true
  end

  create_table "fm_regions", id: false, force: :cascade do |t|
    t.string "code", limit: 255
    t.string "name", limit: 255
    t.index ["code"], name: "fm_regions_code_key", unique: true
  end

  create_table "fm_security_types", id: false, force: :cascade do |t|
    t.uuid "id", default: -> { "gen_random_uuid()" }, null: false
    t.string "title", null: false
    t.string "description"
    t.integer "sort_order", null: false
    t.index ["id"], name: "fm_security_types_id_idx"
  end

  create_table "fm_static_data", id: false, force: :cascade do |t|
    t.string "key", null: false
    t.jsonb "value"
    t.index ["key"], name: "fm_static_data_key_idx"
  end

  create_table "fm_suppliers", primary_key: "supplier_id", id: :uuid, default: nil, force: :cascade do |t|
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "((data -> 'lots'::text))", name: "idxginlots", using: :gin
    t.index ["data"], name: "idxgin", using: :gin
    t.index ["data"], name: "idxginp", opclass: :jsonb_path_ops, using: :gin
  end

  create_table "fm_units_of_measurement", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "title_text", null: false
    t.string "example_text"
    t.string "unit_text"
    t.string "data_type"
    t.string "spreadsheet_label"
    t.text "service_usage", array: true
  end

  create_table "fm_uom_values", id: false, force: :cascade do |t|
    t.string "user_id"
    t.string "service_code"
    t.string "uom_value"
    t.string "building_id"
    t.index ["user_id", "service_code", "building_id"], name: "fm_uom_values_user_id_idx"
  end

  create_table "legal_services_admin_uploads", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "aasm_state", limit: 15
    t.string "suppliers", limit: 255
    t.string "supplier_lot_1_service_offerings", limit: 255
    t.string "supplier_lot_2_service_offerings", limit: 255
    t.string "supplier_lot_3_service_offerings", limit: 255
    t.string "supplier_lot_4_service_offerings", limit: 255
    t.string "rate_cards", limit: 255
    t.jsonb "data"
    t.text "fail_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "suppliers_data"
  end

  create_table "legal_services_regional_availabilities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "legal_services_supplier_id", null: false
    t.text "region_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "service_code"
    t.index ["legal_services_supplier_id"], name: "index_ls_regional_availabilities_on_ls_supplier_id"
  end

  create_table "legal_services_service_offerings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "legal_services_supplier_id", null: false
    t.text "lot_number", null: false
    t.text "service_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["legal_services_supplier_id"], name: "index_ls_service_offerings_on_ls_supplier_id"
  end

  create_table "legal_services_suppliers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "name", null: false
    t.text "email"
    t.text "phone_number"
    t.text "website"
    t.text "address"
    t.boolean "sme"
    t.integer "duns"
    t.text "lot_1_prospectus_link"
    t.text "lot_2_prospectus_link"
    t.text "lot_3_prospectus_link"
    t.text "lot_4_prospectus_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "rate_cards"
    t.index ["rate_cards"], name: "index_legal_services_suppliers_on_rate_cards", using: :gin
  end

  create_table "legal_services_uploads", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "london_postcodes", id: false, force: :cascade do |t|
    t.text "postcode"
    t.text "In Use"
    t.text "region"
    t.text "Last updated"
  end

  create_table "management_consultancy_admin_uploads", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "aasm_state", limit: 15
    t.text "fail_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "suppliers_data"
  end

  create_table "management_consultancy_rate_cards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "management_consultancy_supplier_id", null: false
    t.string "lot"
    t.integer "junior_rate_in_pence"
    t.integer "standard_rate_in_pence"
    t.integer "senior_rate_in_pence"
    t.integer "principal_rate_in_pence"
    t.integer "managing_rate_in_pence"
    t.integer "director_rate_in_pence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "contact_name"
    t.string "telephone_number"
    t.string "email"
    t.index ["management_consultancy_supplier_id"], name: "index_management_consultancy_rate_cards_on_supplier_id"
  end

  create_table "management_consultancy_regional_availabilities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "management_consultancy_supplier_id", null: false
    t.text "lot_number", null: false
    t.text "region_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "expenses_required", null: false
    t.index ["management_consultancy_supplier_id"], name: "index_mc_regional_availabilities_on_mc_supplier_id"
  end

  create_table "management_consultancy_service_offerings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "management_consultancy_supplier_id", null: false
    t.text "lot_number", null: false
    t.text "service_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["management_consultancy_supplier_id"], name: "index_mc_service_offerings_on_mc_supplier_id"
  end

  create_table "management_consultancy_suppliers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "contact_name"
    t.text "contact_email"
    t.text "telephone_number"
    t.boolean "sme"
    t.string "address"
    t.string "website"
    t.integer "duns"
  end

  create_table "management_consultancy_uploads", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nuts_regions", id: false, force: :cascade do |t|
    t.string "code", limit: 255
    t.string "name", limit: 255
    t.string "nuts1_code", limit: 255
    t.string "nuts2_code", limit: 255
    t.index ["code"], name: "nuts_regions_code_key", unique: true
  end

  create_table "os_address", id: false, force: :cascade do |t|
    t.bigint "uprn", null: false
    t.bigint "udprn"
    t.string "change_type"
    t.bigint "state"
    t.date "state_date"
    t.string "class"
    t.bigint "parent_uprn"
    t.decimal "x_coordinate"
    t.decimal "y_coordinate"
    t.decimal "latitude"
    t.decimal "longitude"
    t.bigint "rpc"
    t.bigint "local_custodian_code"
    t.string "country"
    t.date "la_start_date"
    t.date "last_update_date"
    t.date "entry_date"
    t.string "rm_organisation_name"
    t.string "la_organisation"
    t.string "department_name"
    t.string "legal_name"
    t.string "sub_building_name"
    t.string "building_name"
    t.string "building_number"
    t.bigint "sao_start_number"
    t.string "sao_start_suffix"
    t.bigint "sao_end_number"
    t.string "sao_end_suffix"
    t.string "sao_text"
    t.string "alt_language_sao_text"
    t.bigint "pao_start_number"
    t.string "pao_start_suffix"
    t.bigint "pao_end_number"
    t.string "pao_end_suffix"
    t.string "pao_text"
    t.string "alt_language_pao_text"
    t.bigint "usrn"
    t.string "usrn_match_indicator"
    t.string "area_name"
    t.string "level"
    t.string "official_flag"
    t.string "os_address_toid"
    t.bigint "os_address_toid_version"
    t.string "os_roadlink_toid"
    t.bigint "os_roadlink_toid_version"
    t.string "os_topo_toid"
    t.bigint "os_topo_toid_version"
    t.bigint "voa_ct_record"
    t.bigint "voa_ndr_record"
    t.string "street_description"
    t.string "alt_language_street_description"
    t.string "dependent_thoroughfare"
    t.string "thoroughfare"
    t.string "welsh_dependent_thoroughfare"
    t.string "welsh_thoroughfare"
    t.string "double_dependent_locality"
    t.string "dependent_locality"
    t.string "locality"
    t.string "welsh_dependent_locality"
    t.string "welsh_double_dependent_locality"
    t.string "town_name"
    t.string "administrative_area"
    t.string "post_town"
    t.string "welsh_post_town"
    t.string "postcode"
    t.string "postcode_locator"
    t.string "postcode_type"
    t.string "delivery_point_suffix"
    t.string "addressbase_postal"
    t.string "po_box_number"
    t.string "ward_code"
    t.string "parish_code"
    t.date "rm_start_date"
    t.bigint "multi_occ_count"
    t.string "voa_ndr_p_desc_code"
    t.string "voa_ndr_scat_code"
    t.string "alt_language"
    t.index ["postcode"], name: "idx_postcode"
  end

  create_table "os_address_admin_uploads", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "filename", limit: 255
    t.integer "size"
    t.string "etag", limit: 255
    t.text "fail_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["filename"], name: "os_address_admin_uploads_filename_idx", unique: true
  end

  create_table "supply_teachers_admin_current_data", force: :cascade do |t|
    t.string "current_accredited_suppliers", limit: 255
    t.string "geographical_data_all_suppliers", limit: 255
    t.string "lot_1_and_lot_2_comparisons", limit: 255
    t.string "master_vendor_contacts", limit: 255
    t.string "neutral_vendor_contacts", limit: 255
    t.string "pricing_for_tool", limit: 255
    t.string "supplier_lookup", limit: 255
    t.string "data", limit: 255
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "supply_teachers_admin_uploads", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "aasm_state", limit: 15
    t.string "current_accredited_suppliers", limit: 255
    t.string "geographical_data_all_suppliers", limit: 255
    t.string "lot_1_and_lot_2_comparisons", limit: 255
    t.string "master_vendor_contacts", limit: 255
    t.string "neutral_vendor_contacts", limit: 255
    t.string "pricing_for_tool", limit: 255
    t.string "supplier_lookup", limit: 255
    t.text "fail_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "supply_teachers_branches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "supply_teachers_supplier_id", null: false
    t.string "postcode", limit: 8, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.geography "location", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.text "contact_name"
    t.text "contact_email"
    t.text "telephone_number"
    t.text "name"
    t.text "town"
    t.string "address_1"
    t.string "address_2"
    t.string "county"
    t.string "region"
    t.string "slug"
    t.index ["slug"], name: "index_supply_teachers_branches_on_slug", unique: true
    t.index ["supply_teachers_supplier_id"], name: "index_supply_teachers_branches_on_supply_teachers_supplier_id"
  end

  create_table "supply_teachers_rates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "supply_teachers_supplier_id", null: false
    t.text "job_type", null: false
    t.float "mark_up"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "term"
    t.integer "lot_number", default: 1, null: false
    t.money "daily_fee", scale: 2
    t.index ["supply_teachers_supplier_id"], name: "index_supply_teachers_rates_on_supply_teachers_supplier_id"
  end

  create_table "supply_teachers_suppliers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "neutral_vendor_contact_name"
    t.text "neutral_vendor_telephone_number"
    t.text "neutral_vendor_contact_email"
    t.text "master_vendor_contact_name"
    t.text "master_vendor_telephone_number"
    t.text "master_vendor_contact_email"
  end

  create_table "supply_teachers_uploads", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.string "phone_number", limit: 255
    t.string "mobile_number", limit: 255
    t.datetime "confirmed_at"
    t.string "cognito_uuid", limit: 255
    t.integer "roles_mask"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "facilities_management_procurements", "users"
  add_foreign_key "facilities_management_regional_availabilities", "facilities_management_suppliers"
  add_foreign_key "facilities_management_service_offerings", "facilities_management_suppliers"
  add_foreign_key "legal_services_regional_availabilities", "legal_services_suppliers"
  add_foreign_key "legal_services_service_offerings", "legal_services_suppliers"
  add_foreign_key "management_consultancy_rate_cards", "management_consultancy_suppliers"
  add_foreign_key "management_consultancy_regional_availabilities", "management_consultancy_suppliers"
  add_foreign_key "management_consultancy_service_offerings", "management_consultancy_suppliers"
  add_foreign_key "supply_teachers_branches", "supply_teachers_suppliers"
  add_foreign_key "supply_teachers_rates", "supply_teachers_suppliers"
end
