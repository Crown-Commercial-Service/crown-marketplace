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

ActiveRecord::Schema.define(version: 2019_05_21_111111) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "postgis"

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

  create_table "management_consultancy_admin_uploads", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "aasm_state", limit: 15
    t.string "suppliers", limit: 255
    t.string "supplier_service_offerings", limit: 255
    t.string "supplier_regional_offerings", limit: 255
    t.string "rate_cards", limit: 255
    t.text "fail_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  add_foreign_key "facilities_management_regional_availabilities", "facilities_management_suppliers"
  add_foreign_key "facilities_management_service_offerings", "facilities_management_suppliers"
  add_foreign_key "management_consultancy_rate_cards", "management_consultancy_suppliers"
  add_foreign_key "management_consultancy_regional_availabilities", "management_consultancy_suppliers"
  add_foreign_key "management_consultancy_service_offerings", "management_consultancy_suppliers"
  add_foreign_key "supply_teachers_branches", "supply_teachers_suppliers"
  add_foreign_key "supply_teachers_rates", "supply_teachers_suppliers"
end
