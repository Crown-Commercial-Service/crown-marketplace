# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_09_02_073259) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"
  enable_extension "postgis"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.uuid "record_id"
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bank_holidays", force: :cascade do |t|
    t.text "title"
    t.date "date"
    t.text "notes"
    t.boolean "bunting"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_bank_holidays_on_date"
  end

  create_table "facilities_management_buildings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "updated_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.string "status", default: "Incomplete", null: false
    t.text "updated_by"
    t.text "building_name"
    t.text "description"
    t.integer "gia"
    t.text "building_type"
    t.text "security_type"
    t.text "address_town"
    t.text "address_line_1"
    t.text "address_line_2"
    t.text "address_postcode"
    t.text "address_region"
    t.text "address_region_code"
    t.uuid "user_id"
    t.string "other_building_type"
    t.string "other_security_type"
    t.bigint "external_area"
    t.index "lower(building_name)", name: "index_fm_buildings_on_lower_building_name"
    t.index ["id"], name: "index_facilities_management_buildings_on_id", unique: true
    t.index ["user_id", "building_name"], name: "index_building_bulding_name_and_user_id", unique: true
    t.index ["user_id"], name: "idx_buildings_user_id"
  end

  create_table "facilities_management_buyer_details", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "full_name", limit: 255
    t.string "job_title", limit: 255
    t.string "telephone_number", limit: 255
    t.string "organisation_name", limit: 255
    t.string "organisation_address_line_1", limit: 255
    t.string "organisation_address_line_2", limit: 255
    t.string "organisation_address_town", limit: 255
    t.string "organisation_address_county", limit: 255
    t.string "organisation_address_postcode", limit: 255
    t.boolean "central_government"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.uuid "user_id", null: false
    t.boolean "contact_opt_in"
    t.string "sector", limit: 255
    t.index ["user_id"], name: "index_facilities_management_buyer_details_on_user_id"
  end

  create_table "facilities_management_procurement_building_service_lifts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "facilities_management_rm3830_procurement_building_service_id", null: false
    t.integer "number_of_floors"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["facilities_management_rm3830_procurement_building_service_id"], name: "index_fmpbs_procurement_lifts_on_fmp_building_services_id"
  end

  create_table "facilities_management_regions", id: false, force: :cascade do |t|
    t.text "code"
    t.text "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["code"], name: "fm_regions_code_key", unique: true
  end

  create_table "facilities_management_rm3830_admin_management_reports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.string "aasm_state", limit: 30
    t.uuid "user_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_fm_rm3830_management_reports_on_user_id"
  end

  create_table "facilities_management_rm3830_admin_uploads", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "aasm_state", limit: 30
    t.text "import_errors"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id"
    t.index ["user_id"], name: "index_fm_rm3830_uploads_on_users_id"
  end

  create_table "facilities_management_rm3830_frozen_rate_cards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "facilities_management_rm3830_procurement_id", null: false
    t.jsonb "data"
    t.text "source_file", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["data"], name: "idx_fm_frozen_rate_cards_gin", using: :gin
    t.index ["data"], name: "idx_fm_frozen_rate_cards_ginp", opclass: :jsonb_path_ops, using: :gin
    t.index ["facilities_management_rm3830_procurement_id"], name: "index_frozen_fm_rate_cards_procurement"
  end

  create_table "facilities_management_rm3830_frozen_rates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "facilities_management_rm3830_procurement_id", null: false
    t.string "code", limit: 5
    t.decimal "framework"
    t.decimal "benchmark"
    t.string "standard", limit: 1
    t.boolean "direct_award"
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "updated_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.index ["facilities_management_rm3830_procurement_id"], name: "index_frozen_fm_rates_procurement"
  end

  create_table "facilities_management_rm3830_procurement_building_services", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "facilities_management_rm3830_procurement_building_id", null: false
    t.string "code", limit: 10
    t.string "name", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "no_of_appliances_for_testing"
    t.bigint "no_of_building_occupants"
    t.bigint "no_of_consoles_to_be_serviced"
    t.bigint "tones_to_be_collected_and_removed"
    t.bigint "no_of_units_to_be_serviced"
    t.string "service_standard", limit: 1
    t.bigint "service_hours"
    t.text "detail_of_requirement"
    t.uuid "facilities_management_rm3830_procurement_id"
    t.index ["code"], name: "index_fm_procurement_building_services_on_code"
    t.index ["facilities_management_rm3830_procurement_building_id", "code"], name: "idx_fm_pbs_on_fm_pb_and_code"
    t.index ["facilities_management_rm3830_procurement_building_id"], name: "index_fm_procurements_on_fm_procurement_building_id"
    t.index ["facilities_management_rm3830_procurement_id", "facilities_management_rm3830_procurement_building_id"], name: "idx_fm_pbs_fm_p_fm_pb"
    t.index ["facilities_management_rm3830_procurement_id"], name: "index_fm_procurement_building_services_on_fm_procurement_id"
  end

  create_table "facilities_management_rm3830_procurement_buildings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "facilities_management_rm3830_procurement_id", null: false
    t.text "service_codes", default: [], array: true
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "active"
    t.uuid "building_id"
    t.integer "gia"
    t.text "building_type"
    t.text "security_type"
    t.text "address_town"
    t.text "address_line_1"
    t.text "address_line_2"
    t.text "address_postcode"
    t.text "address_region"
    t.text "address_region_code"
    t.text "building_name"
    t.text "description"
    t.bigint "external_area"
    t.string "other_building_type"
    t.string "other_security_type"
    t.index ["active"], name: "index_fm_procurement_buildings_on_active"
    t.index ["building_id"], name: "index_fm_procurement_buildings_on_building_id"
    t.index ["facilities_management_rm3830_procurement_id"], name: "index_fm_procurements_on_fm_procurement_id"
    t.index ["service_codes"], name: "index_fm_procurement_buildings_on_service_codes"
  end

  create_table "facilities_management_rm3830_procurement_contact_details", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "type", limit: 100
    t.string "name", limit: 50
    t.string "job_title", limit: 150
    t.text "email"
    t.string "telephone_number", limit: 15
    t.text "organisation_address_line_1"
    t.text "organisation_address_line_2"
    t.text "organisation_address_town"
    t.text "organisation_address_county"
    t.text "organisation_address_postcode"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.uuid "facilities_management_rm3830_procurement_id"
    t.index ["email"], name: "facilities_management_procurement_contact_detail_email_idx"
    t.index ["facilities_management_rm3830_procurement_id"], name: "index_fm_procurement_contact_details_on_fm_procurement_id"
    t.index ["id"], name: "facilities_management_procurement_contact_detail_id_idx"
  end

  create_table "facilities_management_rm3830_procurement_extensions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "facilities_management_rm3830_procurement_id"
    t.integer "extension"
    t.integer "years"
    t.integer "months"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["facilities_management_rm3830_procurement_id"], name: "index_optional_call_off_on_fm_procurements_id"
  end

  create_table "facilities_management_rm3830_procurement_pension_funds", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "facilities_management_rm3830_procurement_id", null: false
    t.string "name", limit: 150
    t.float "percentage"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["facilities_management_rm3830_procurement_id"], name: "index_fm_procurement_pension_funds_on_fm_procurement_id"
    t.index ["name", "facilities_management_rm3830_procurement_id"], name: "index_pension_funds_name_and_procurement_id", unique: true
  end

  create_table "facilities_management_rm3830_procurement_suppliers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "facilities_management_rm3830_procurement_id", null: false
    t.uuid "supplier_id"
    t.money "direct_award_value", scale: 2, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "contract_number"
    t.string "aasm_state", limit: 30
    t.datetime "offer_sent_date", precision: nil
    t.datetime "supplier_response_date", precision: nil
    t.datetime "contract_start_date", precision: nil
    t.datetime "contract_end_date", precision: nil
    t.datetime "contract_signed_date", precision: nil
    t.datetime "contract_closed_date", precision: nil
    t.text "reason_for_closing"
    t.text "reason_for_declining"
    t.text "reason_for_not_signing"
    t.boolean "contract_documents_zip_generated"
    t.index ["facilities_management_rm3830_procurement_id"], name: "index_fm_procurement_supplier_on_fm_procurement_id"
  end

  create_table "facilities_management_rm3830_procurements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "aasm_state", limit: 30
    t.string "updated_by", limit: 100
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "service_codes", default: [], array: true
    t.text "region_codes", default: [], array: true
    t.string "contract_name", limit: 100
    t.integer "estimated_annual_cost"
    t.boolean "tupe"
    t.integer "initial_call_off_period_years"
    t.date "initial_call_off_start_date"
    t.date "initial_call_off_end_date"
    t.integer "mobilisation_period"
    t.boolean "estimated_cost_known"
    t.boolean "mobilisation_period_required"
    t.boolean "extensions_required"
    t.boolean "security_policy_document_required"
    t.string "security_policy_document_name"
    t.string "security_policy_document_version_number"
    t.date "security_policy_document_date"
    t.string "lot_number"
    t.money "assessed_value", scale: 2
    t.boolean "eligible_for_da"
    t.string "da_journey_state"
    t.string "payment_method"
    t.boolean "using_buyer_detail_for_invoice_details"
    t.boolean "using_buyer_detail_for_notices_detail"
    t.boolean "using_buyer_detail_for_authorised_detail"
    t.boolean "local_government_pension_scheme"
    t.string "contract_number"
    t.string "contract_datetime"
    t.boolean "lot_number_selected_by_customer", default: false
    t.string "governing_law"
    t.integer "initial_call_off_period_months"
    t.index ["user_id"], name: "index_facilities_management_rm3830_procurements_on_user_id"
  end

  create_table "facilities_management_rm3830_rate_cards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "data"
    t.text "source_file", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["data"], name: "idx_fm_rate_cards_gin", using: :gin
    t.index ["data"], name: "idx_fm_rate_cards_ginp", opclass: :jsonb_path_ops, using: :gin
  end

  create_table "facilities_management_rm3830_rates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code", limit: 5
    t.decimal "framework"
    t.decimal "benchmark"
    t.string "standard", limit: 1
    t.boolean "direct_award"
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "updated_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.index ["code", "standard"], name: "index_facilities_management_rm3830_rates_on_code_and_standard"
    t.index ["code"], name: "index_facilities_management_rm3830_rates_on_code"
  end

  create_table "facilities_management_rm3830_spreadsheet_imports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "facilities_management_rm3830_procurement_id", null: false
    t.string "aasm_state", limit: 15
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.json "import_errors", default: {}
    t.string "data_import_state", limit: 30
    t.index ["facilities_management_rm3830_procurement_id"], name: "index_fm_procurements_on_fm_spreadsheet_imports_id"
  end

  create_table "facilities_management_rm3830_static_data", id: false, force: :cascade do |t|
    t.string "key", null: false
    t.jsonb "value"
    t.index ["key"], name: "facilities_management_rm3830_static_data_key_idx"
  end

  create_table "facilities_management_rm3830_supplier_details", primary_key: "supplier_id", id: :uuid, default: nil, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "contact_name"
    t.string "contact_email"
    t.string "contact_phone"
    t.string "supplier_name"
    t.jsonb "lot_data", default: {}
    t.uuid "user_id"
    t.boolean "sme"
    t.string "duns", limit: 255
    t.string "registration_number", limit: 255
    t.string "address_line_1", limit: 255
    t.string "address_line_2", limit: 255
    t.string "address_town", limit: 255
    t.string "address_county", limit: 255
    t.string "address_postcode", limit: 255
    t.index ["contact_email"], name: "index_fm_rm3830_supplier_details_on_contact_email"
    t.index ["supplier_name"], name: "index_fm_rm3830_supplier_details_on_supplier_name", unique: true
    t.index ["user_id"], name: "index_facilities_management_rm3830_supplier_details_on_user_id"
  end

  create_table "facilities_management_rm3830_units_of_measurements", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "title_text", null: false
    t.string "example_text"
    t.string "unit_text"
    t.string "data_type"
    t.string "spreadsheet_label"
    t.string "unit_measure_label"
    t.text "service_usage", array: true
  end

  create_table "facilities_management_rm6232_admin_management_reports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.string "aasm_state", limit: 30
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_fm_rm6232_management_reports_on_user_id"
  end

  create_table "facilities_management_rm6232_admin_supplier_data", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "facilities_management_rm6232_admin_upload_id"
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facilities_management_rm6232_admin_upload_id"], name: "index_fm_rm6232_supplier_data_on_fm_rm6232_admin_upload_id "
  end

  create_table "facilities_management_rm6232_admin_supplier_data_edits", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "facilities_management_rm6232_admin_supplier_data_id", null: false
    t.uuid "user_id"
    t.uuid "supplier_id"
    t.string "change_type", limit: 255
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facilities_management_rm6232_admin_supplier_data_id"], name: "index_fm_rm6232_admin_sd_edits_on_fm_rm6232_admin_sd_id "
    t.index ["user_id"], name: "index_fm_rm6232_admin_sd_edits_on_user_id"
  end

  create_table "facilities_management_rm6232_admin_uploads", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "aasm_state", limit: 30
    t.text "import_errors"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id"
    t.index ["user_id"], name: "index_fm_rm6232_uploads_on_users_id"
  end

  create_table "facilities_management_rm6232_procurement_buildings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "facilities_management_rm6232_procurement_id"
    t.uuid "building_id"
    t.boolean "active"
    t.text "service_codes", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "frozen_building_data", default: {}
    t.index ["active"], name: "index_fm_rm6232_procurement_buildings_on_active"
    t.index ["building_id"], name: "index_building_on_fm_rm6232_procurements_id"
    t.index ["facilities_management_rm6232_procurement_id"], name: "index_procurement_building_on_fm_rm6232_procurements_id"
  end

  create_table "facilities_management_rm6232_procurement_extensions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "facilities_management_rm6232_procurement_id"
    t.integer "extension"
    t.integer "years"
    t.integer "months"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facilities_management_rm6232_procurement_id"], name: "index_optional_call_off_on_fm_rm6232_procurements_id"
  end

  create_table "facilities_management_rm6232_procurements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "aasm_state", limit: 30
    t.text "service_codes", default: [], array: true
    t.text "region_codes", default: [], array: true
    t.bigint "annual_contract_value"
    t.string "contract_name", limit: 100
    t.string "lot_number", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "contract_number"
    t.boolean "tupe"
    t.integer "initial_call_off_period_years"
    t.integer "initial_call_off_period_months"
    t.date "initial_call_off_start_date"
    t.boolean "mobilisation_period_required"
    t.integer "mobilisation_period"
    t.boolean "extensions_required"
    t.boolean "requirements_linked_to_pfi"
    t.index ["user_id", "contract_name"], name: "index_rm6232_procurement_name_and_user_id", unique: true
    t.index ["user_id"], name: "index_fm_rm6232_procurements_on_user_id"
  end

  create_table "facilities_management_rm6232_services", primary_key: "code", id: { type: :string, limit: 5 }, force: :cascade do |t|
    t.string "work_package_code", limit: 1, null: false
    t.string "name", limit: 150
    t.text "description"
    t.boolean "core"
    t.boolean "total"
    t.boolean "hard"
    t.boolean "soft"
    t.integer "sort_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_facilities_management_rm6232_services_on_code"
    t.index ["hard"], name: "index_facilities_management_rm6232_services_on_hard"
    t.index ["soft"], name: "index_facilities_management_rm6232_services_on_soft"
    t.index ["sort_order"], name: "index_facilities_management_rm6232_services_on_sort_order"
    t.index ["total"], name: "index_facilities_management_rm6232_services_on_total"
    t.index ["work_package_code"], name: "index_rm6232_fm_services_on_fm_work_packages_code"
  end

  create_table "facilities_management_rm6232_supplier_lot_data", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "facilities_management_rm6232_supplier_id"
    t.string "lot_code", limit: 2
    t.text "service_codes", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "region_codes", default: [], array: true
    t.boolean "active", default: true
    t.index ["facilities_management_rm6232_supplier_id"], name: "index_fm_rm6232_supplier_lot_data_on_fm_rm6232_supplier_id"
    t.index ["lot_code"], name: "index_fm_rm6232_supplier_lot_data_on_lot_number"
  end

  create_table "facilities_management_rm6232_suppliers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "supplier_name", limit: 255
    t.boolean "sme"
    t.string "duns", limit: 255
    t.string "registration_number", limit: 255
    t.string "address_line_1", limit: 255
    t.string "address_line_2", limit: 255
    t.string "address_town", limit: 255
    t.string "address_county", limit: 255
    t.string "address_postcode", limit: 255
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_facilities_management_rm6232_suppliers_on_active"
    t.index ["supplier_name"], name: "index_facilities_management_rm6232_suppliers_on_supplier_name", unique: true
  end

  create_table "facilities_management_rm6232_work_packages", primary_key: "code", id: { type: :string, limit: 1 }, force: :cascade do |t|
    t.string "name", limit: 100
    t.boolean "selectable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_facilities_management_rm6232_work_packages_on_code"
    t.index ["selectable"], name: "index_facilities_management_rm6232_work_packages_on_selectable"
  end

  create_table "facilities_management_security_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "title", null: false
    t.text "description"
    t.integer "sort_order"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["id"], name: "index_facilities_management_security_types_on_id"
  end

  create_table "frameworks", id: :text, force: :cascade do |t|
    t.text "service"
    t.date "live_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "expires_at"
  end

  create_table "jurisdictions", id: :text, force: :cascade do |t|
    t.text "name"
    t.text "mapping_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lots", id: :text, force: :cascade do |t|
    t.text "framework_id", null: false
    t.text "number", null: false
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["framework_id"], name: "index_lots_on_framework_id"
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
    t.index ["postcode_locator"], name: "index_os_address_on_postcode_locator"
  end

  create_table "os_address_admin_uploads", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "filename", limit: 255
    t.integer "size"
    t.string "etag", limit: 255
    t.text "fail_reason"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["filename"], name: "os_address_admin_uploads_filename_idx", unique: true
  end

  create_table "positions", id: :text, force: :cascade do |t|
    t.text "lot_id", null: false
    t.integer "number", null: false
    t.text "name", null: false
    t.text "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lot_id"], name: "index_positions_on_lot_id"
  end

  create_table "postcodes_nuts_regions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "postcode", limit: 20
    t.string "code", limit: 20
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["postcode"], name: "index_postcodes_nuts_regions_on_postcode", unique: true
  end

  create_table "reports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.text "framework_id", null: false
    t.string "aasm_state", limit: 30
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["framework_id"], name: "index_reports_on_framework_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "searches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.text "framework_id", null: false
    t.uuid "session_id"
    t.text "search_criteria"
    t.text "search_result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["framework_id"], name: "index_searches_on_framework_id"
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

  create_table "services", id: :text, force: :cascade do |t|
    t.text "lot_id", null: false
    t.text "number", null: false
    t.text "name", null: false
    t.text "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lot_id"], name: "index_services_on_lot_id"
  end

  create_table "supplier_framework_addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "supplier_framework_id", null: false
    t.text "address_line_1"
    t.text "address_line_2"
    t.text "town"
    t.text "county"
    t.text "postcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supplier_framework_id"], name: "index_supplier_framework_addresses_on_supplier_framework_id"
  end

  create_table "supplier_framework_contact_details", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "supplier_framework_id", null: false
    t.text "name"
    t.text "email"
    t.text "telephone_number"
    t.text "website"
    t.jsonb "additional_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supplier_framework_id"], name: "idx_on_supplier_framework_id_9cfb9d6920"
  end

  create_table "supplier_framework_lot_branches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "supplier_framework_lot_id", null: false
    t.text "slug"
    t.geography "location", limit: {srid: 4326, type: "st_point", geographic: true}
    t.string "postcode", limit: 8, null: false
    t.text "contact_name"
    t.text "contact_email"
    t.text "telephone_number"
    t.text "name"
    t.text "town"
    t.text "address_line_1"
    t.text "address_line_2"
    t.text "county"
    t.text "region"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_supplier_framework_lot_branches_on_slug"
    t.index ["supplier_framework_lot_id"], name: "idx_on_supplier_framework_lot_id_5cc87a7153"
  end

  create_table "supplier_framework_lot_jurisdictions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "supplier_framework_lot_id", null: false
    t.text "jurisdiction_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jurisdiction_id"], name: "index_supplier_framework_lot_jurisdictions_on_jurisdiction_id"
    t.index ["supplier_framework_lot_id", "jurisdiction_id"], name: "idx_on_supplier_framework_lot_id_jurisdiction_id_bf241ce276", unique: true
    t.index ["supplier_framework_lot_id"], name: "idx_on_supplier_framework_lot_id_57bebdac3f"
  end

  create_table "supplier_framework_lot_rates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "supplier_framework_lot_id", null: false
    t.text "position_id", null: false
    t.uuid "supplier_framework_lot_jurisdiction_id", null: false
    t.integer "rate", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position_id"], name: "index_supplier_framework_lot_rates_on_position_id"
    t.index ["supplier_framework_lot_id", "position_id", "supplier_framework_lot_jurisdiction_id"], name: "idx_on_supplier_framework_lot_id_position_id_suppli_ed53e87c0a", unique: true
    t.index ["supplier_framework_lot_id"], name: "idx_on_supplier_framework_lot_id_03e2196cfb"
    t.index ["supplier_framework_lot_jurisdiction_id"], name: "idx_on_supplier_framework_lot_jurisdiction_id_e5ffe73c62"
  end

  create_table "supplier_framework_lot_services", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "supplier_framework_lot_id", null: false
    t.text "service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_supplier_framework_lot_services_on_service_id"
    t.index ["supplier_framework_lot_id", "service_id"], name: "idx_on_supplier_framework_lot_id_service_id_1b881a56ab", unique: true
    t.index ["supplier_framework_lot_id"], name: "idx_on_supplier_framework_lot_id_21d10a1b69"
  end

  create_table "supplier_framework_lots", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "supplier_framework_id", null: false
    t.text "lot_id", null: false
    t.boolean "enabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lot_id"], name: "index_supplier_framework_lots_on_lot_id"
    t.index ["supplier_framework_id", "lot_id"], name: "idx_on_supplier_framework_id_lot_id_d9c0566119", unique: true
    t.index ["supplier_framework_id"], name: "index_supplier_framework_lots_on_supplier_framework_id"
  end

  create_table "supplier_frameworks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "supplier_id", null: false
    t.text "framework_id", null: false
    t.boolean "enabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["framework_id"], name: "index_supplier_frameworks_on_framework_id"
    t.index ["supplier_id", "framework_id"], name: "index_supplier_frameworks_on_supplier_id_and_framework_id", unique: true
    t.index ["supplier_id"], name: "index_supplier_frameworks_on_supplier_id"
  end

  create_table "suppliers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "name", null: false
    t.text "duns_number"
    t.boolean "sme"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["duns_number"], name: "index_suppliers_on_duns_number", unique: true
    t.index ["name"], name: "index_suppliers_on_name", unique: true
  end

  create_table "uploads", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "framework_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["framework_id"], name: "index_uploads_on_framework_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.string "phone_number", limit: 255
    t.string "mobile_number", limit: 255
    t.datetime "confirmed_at", precision: nil
    t.string "cognito_uuid", limit: 255
    t.integer "roles_mask"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "session_token", limit: 255
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["session_token"], name: "index_users_on_session_token"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "facilities_management_buyer_details", "users"
  add_foreign_key "facilities_management_procurement_building_service_lifts", "facilities_management_rm3830_procurement_building_services"
  add_foreign_key "facilities_management_rm3830_admin_management_reports", "users"
  add_foreign_key "facilities_management_rm3830_admin_uploads", "users"
  add_foreign_key "facilities_management_rm3830_frozen_rate_cards", "facilities_management_rm3830_procurements"
  add_foreign_key "facilities_management_rm3830_frozen_rates", "facilities_management_rm3830_procurements"
  add_foreign_key "facilities_management_rm3830_procurement_building_services", "facilities_management_rm3830_procurement_buildings"
  add_foreign_key "facilities_management_rm3830_procurement_building_services", "facilities_management_rm3830_procurements"
  add_foreign_key "facilities_management_rm3830_procurement_buildings", "facilities_management_rm3830_procurements"
  add_foreign_key "facilities_management_rm3830_procurement_contact_details", "facilities_management_rm3830_procurements"
  add_foreign_key "facilities_management_rm3830_procurement_extensions", "facilities_management_rm3830_procurements"
  add_foreign_key "facilities_management_rm3830_procurement_pension_funds", "facilities_management_rm3830_procurements"
  add_foreign_key "facilities_management_rm3830_procurement_suppliers", "facilities_management_rm3830_procurements"
  add_foreign_key "facilities_management_rm3830_procurements", "users"
  add_foreign_key "facilities_management_rm3830_spreadsheet_imports", "facilities_management_rm3830_procurements"
  add_foreign_key "facilities_management_rm3830_supplier_details", "users"
  add_foreign_key "facilities_management_rm6232_admin_management_reports", "users"
  add_foreign_key "facilities_management_rm6232_admin_supplier_data", "facilities_management_rm6232_admin_uploads"
  add_foreign_key "facilities_management_rm6232_admin_supplier_data_edits", "facilities_management_rm6232_admin_supplier_data", column: "facilities_management_rm6232_admin_supplier_data_id"
  add_foreign_key "facilities_management_rm6232_admin_supplier_data_edits", "users"
  add_foreign_key "facilities_management_rm6232_admin_uploads", "users"
  add_foreign_key "facilities_management_rm6232_procurement_buildings", "facilities_management_buildings", column: "building_id"
  add_foreign_key "facilities_management_rm6232_procurement_buildings", "facilities_management_rm6232_procurements"
  add_foreign_key "facilities_management_rm6232_procurement_extensions", "facilities_management_rm6232_procurements"
  add_foreign_key "facilities_management_rm6232_procurements", "users"
  add_foreign_key "facilities_management_rm6232_services", "facilities_management_rm6232_work_packages", column: "work_package_code", primary_key: "code"
  add_foreign_key "facilities_management_rm6232_supplier_lot_data", "facilities_management_rm6232_suppliers"
  add_foreign_key "lots", "frameworks"
  add_foreign_key "positions", "lots"
  add_foreign_key "reports", "frameworks"
  add_foreign_key "reports", "users"
  add_foreign_key "searches", "frameworks"
  add_foreign_key "searches", "users"
  add_foreign_key "services", "lots"
  add_foreign_key "supplier_framework_addresses", "supplier_frameworks"
  add_foreign_key "supplier_framework_contact_details", "supplier_frameworks"
  add_foreign_key "supplier_framework_lot_branches", "supplier_framework_lots"
  add_foreign_key "supplier_framework_lot_jurisdictions", "jurisdictions"
  add_foreign_key "supplier_framework_lot_jurisdictions", "supplier_framework_lots"
  add_foreign_key "supplier_framework_lot_rates", "positions"
  add_foreign_key "supplier_framework_lot_rates", "supplier_framework_lot_jurisdictions"
  add_foreign_key "supplier_framework_lot_rates", "supplier_framework_lots"
  add_foreign_key "supplier_framework_lot_services", "services"
  add_foreign_key "supplier_framework_lot_services", "supplier_framework_lots"
  add_foreign_key "supplier_framework_lots", "lots"
  add_foreign_key "supplier_framework_lots", "supplier_frameworks"
  add_foreign_key "supplier_frameworks", "frameworks"
  add_foreign_key "supplier_frameworks", "suppliers"
  add_foreign_key "uploads", "frameworks"
end
