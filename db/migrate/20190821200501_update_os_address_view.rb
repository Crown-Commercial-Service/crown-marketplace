# rubocop:disable: Metrics/AbcSize
# rubocop:disable: Metrics/MethodLength
# rubocop:disable: Metrics/BlockLength
# rubocop:disable: Rails/CreateTableWithTimestamps
class UpdateOsAddressView < ActiveRecord::Migration[5.2]
  def up
    create_table 'os_address', id: false, force: :cascade do |t|
      t.bigint 'uprn', null: false
      t.bigint 'udprn'
      t.text 'change_type'
      t.bigint 'state'
      t.date 'state_date'
      t.text 'class'
      t.bigint 'parent_uprn'
      t.decimal 'x_coordinate'
      t.decimal 'y_coordinate'
      t.decimal 'latitude'
      t.decimal 'longitude'
      t.bigint 'rpc'
      t.bigint 'local_custodian_code'
      t.text 'country'
      t.date 'la_start_date'
      t.date 'last_update_date'
      t.date 'entry_date'
      t.text 'rm_organisation_name'
      t.text 'la_organisation'
      t.text 'department_name'
      t.text 'legal_name'
      t.text 'sub_building_name'
      t.text 'building_name'
      t.text 'building_number'
      t.bigint 'sao_start_number'
      t.text 'sao_start_suffix'
      t.bigint 'sao_end_number'
      t.text 'sao_end_suffix'
      t.text 'sao_text'
      t.text 'alt_language_sao_text'
      t.bigint 'pao_start_number'
      t.text 'pao_start_suffix'
      t.bigint 'pao_end_number'
      t.text 'pao_end_suffix'
      t.text 'pao_text'
      t.text 'alt_language_pao_text'
      t.bigint 'usrn'
      t.text 'usrn_match_indicator'
      t.text 'area_name'
      t.text 'level'
      t.text 'official_flag'
      t.text 'os_address_toid'
      t.bigint 'os_address_toid_version'
      t.text 'os_roadlink_toid'
      t.bigint 'os_roadlink_toid_version'
      t.text 'os_topo_toid'
      t.bigint 'os_topo_toid_version'
      t.bigint 'voa_ct_record'
      t.bigint 'voa_ndr_record'
      t.text 'street_description'
      t.text 'alt_language_street_description'
      t.text 'dependent_thoroughfare'
      t.text 'thoroughfare'
      t.text 'welsh_dependent_thoroughfare'
      t.text 'welsh_thoroughfare'
      t.text 'double_dependent_locality'
      t.text 'dependent_locality'
      t.text 'locality'
      t.text 'welsh_dependent_locality'
      t.text 'welsh_double_dependent_locality'
      t.text 'town_name'
      t.text 'administrative_area'
      t.text 'post_town'
      t.text 'welsh_post_town'
      t.text 'postcode'
      t.text 'postcode_locator'
      t.text 'postcode_type'
      t.text 'delivery_point_suffix'
      t.text 'addressbase_postal'
      t.text 'po_box_number'
      t.text 'ward_code'
      t.text 'parish_code'
      t.date 'rm_start_date'
      t.bigint 'multi_occ_count'
      t.text 'voa_ndr_p_desc_code'
      t.text 'voa_ndr_scat_code'
      t.text 'alt_language'
      t.index ['postcode'], name: 'idx_postcode'
    end

    create_table 'os_address_admin_uploads', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
      t.string 'filename', limit: 255
      t.integer 'size'
      t.string 'etag', limit: 255
      t.text 'fail_reason'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['filename'], name: 'os_address_admin_uploads_filename_idx', unique: true
    end

    execute "create or replace view os_address_view as select ((adds.pao_start_number || adds.pao_start_suffix::text) || ' '::text) || adds.street_description::text as add1, adds.town_name as village, adds.post_town, adds.administrative_area as county, adds.postcode, replace(adds.postcode::text, ' '::text, ''::text) as formated_postcode, replace(adds.postcode::text, ' '::text, adds.delivery_point_suffix::text) as building_ref from os_address adds where ((adds.pao_start_number || adds.pao_start_suffix::text) || adds.street_description::text) is not null and adds.post_town is not null order by adds.pao_start_number, adds.street_description;"
  end

  def down
    execute 'drop view os_address_view'
    drop_table 'os_address_admin_uploads'
    drop_table 'os_address'
  end
end
# rubocop:enable: Metrics/AbcSize
# rubocop:enable: Metrics/BlockLength
# rubocop:enable: Metrics/MethodLength
# rubocop:enable: Rails/CreateTableWithTimestamps
