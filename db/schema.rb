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

ActiveRecord::Schema.define(version: 2019_03_25_092205) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "facilities_management_buildings", id: false, force: :cascade do |t|
    t.string "user_id", null: false
    t.jsonb "building_json", null: false
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

  create_table "fm_suppliers", primary_key: "supplier_id", id: :uuid, default: nil, force: :cascade do |t|
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "((data -> 'lots'::text))", name: "idxginlots", using: :gin
    t.index ["data"], name: "idxgin", using: :gin
    t.index ["data"], name: "idxginp", opclass: :jsonb_path_ops, using: :gin
  end

  create_table "fm_units_of_measurement", id: :serial, force: :cascade do |t|
    t.string "title_text", null: false
    t.string "example_text"
    t.string "unit_text"
    t.string "data_type"
    t.text "service_usage", array: true
  end

  create_table "fm_uom_values", id: false, force: :cascade do |t|
    t.string "user_id"
    t.string "service_code"
    t.string "uom_value"
    t.string "building_id"
    t.index ["user_id", "service_code", "building_id"], name: "fm_uom_values_user_id_idx"
  end

  create_table "london_postcodes", id: false, force: :cascade do |t|
    t.text "postcode"
    t.text "In Use"
    t.text "region"
    t.text "Last updated"
  end

  create_table "management_consultancy_rate_cards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "management_consultancy_supplier_id", null: false
    t.integer "lot"
    t.integer "junior_rate_in_pence"
    t.integer "standard_rate_in_pence"
    t.integer "senior_rate_in_pence"
    t.integer "principal_rate_in_pence"
    t.integer "managing_rate_in_pence"
    t.integer "director_rate_in_pence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
