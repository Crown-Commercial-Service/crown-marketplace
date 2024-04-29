# rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/BlockLength, Migration/RequireLimitOnString, Rails/DangerousColumnNames
class UpdateOsAddressView < ActiveRecord::Migration[5.2]
  def up
    unless ActiveRecord::Base.connection.table_exists?('os_address')
      create_table :os_address, id: false do |t|
        t.bigint 'uprn', null: false
        t.bigint 'udprn'
        t.string 'change_type'
        t.bigint 'state'
        t.date 'state_date'
        t.string 'class'
        t.bigint 'parent_uprn'
        t.decimal 'x_coordinate'
        t.decimal 'y_coordinate'
        t.decimal 'latitude'
        t.decimal 'longitude'
        t.bigint 'rpc'
        t.bigint 'local_custodian_code'
        t.string 'country'
        t.date 'la_start_date'
        t.date 'last_update_date'
        t.date 'entry_date'
        t.string 'rm_organisation_name'
        t.string 'la_organisation'
        t.string 'department_name'
        t.string 'legal_name'
        t.string 'sub_building_name'
        t.string 'building_name'
        t.string 'building_number'
        t.bigint 'sao_start_number'
        t.string 'sao_start_suffix'
        t.bigint 'sao_end_number'
        t.string 'sao_end_suffix'
        t.string 'sao_text'
        t.string 'alt_language_sao_text'
        t.bigint 'pao_start_number'
        t.string 'pao_start_suffix'
        t.bigint 'pao_end_number'
        t.string 'pao_end_suffix'
        t.string 'pao_text'
        t.string 'alt_language_pao_text'
        t.bigint 'usrn'
        t.string 'usrn_match_indicator'
        t.string 'area_name'
        t.string 'level'
        t.string 'official_flag'
        t.string 'os_address_toid'
        t.bigint 'os_address_toid_version'
        t.string 'os_roadlink_toid'
        t.bigint 'os_roadlink_toid_version'
        t.string 'os_topo_toid'
        t.bigint 'os_topo_toid_version'
        t.bigint 'voa_ct_record'
        t.bigint 'voa_ndr_record'
        t.string 'street_description'
        t.string 'alt_language_street_description'
        t.string 'dependent_thoroughfare'
        t.string 'thoroughfare'
        t.string 'welsh_dependent_thoroughfare'
        t.string 'welsh_thoroughfare'
        t.string 'double_dependent_locality'
        t.string 'dependent_locality'
        t.string 'locality'
        t.string 'welsh_dependent_locality'
        t.string 'welsh_double_dependent_locality'
        t.string 'town_name'
        t.string 'administrative_area'
        t.string 'post_town'
        t.string 'welsh_post_town'
        t.string 'postcode'
        t.string 'postcode_locator'
        t.string 'postcode_type'
        t.string 'delivery_point_suffix'
        t.string 'addressbase_postal'
        t.string 'po_box_number'
        t.string 'ward_code'
        t.string 'parish_code'
        t.date 'rm_start_date'
        t.bigint 'multi_occ_count'
        t.string 'voa_ndr_p_desc_code'
        t.string 'voa_ndr_scat_code'
        t.string 'alt_language'
        t.index ['postcode'], name: 'idx_postcode'
      end
    end

    unless ActiveRecord::Base.connection.table_exists?('os_address')
      create_table 'os_address_admin_uploads', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
        t.string 'filename', limit: 255
        t.integer 'size'
        t.string 'etag', limit: 255
        t.text 'fail_reason'
        t.datetime 'created_at', null: false
        t.datetime 'updated_at', null: false
        t.index ['filename'], name: 'os_address_admin_uploads_filename_idx', unique: true
      end
    end

    execute "create or replace view os_address_view as select ((adds.pao_start_number || adds.pao_start_suffix::text) || ' '::text) || adds.street_description::text as add1, adds.town_name as village, adds.post_town, adds.administrative_area as county, adds.postcode, replace(adds.postcode::text, ' '::text, ''::text) as formated_postcode, replace(adds.postcode::text, ' '::text, adds.delivery_point_suffix::text) as building_ref from os_address adds where ((adds.pao_start_number || adds.pao_start_suffix::text) || adds.street_description::text) is not null and adds.post_town is not null order by adds.pao_start_number, adds.street_description;"
  end

  def down
    execute 'drop view os_address_view'
    drop_table 'os_address_admin_uploads'
    drop_table 'os_address'
  end
end
# rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Metrics/BlockLength, Migration/RequireLimitOnString, Rails/DangerousColumnNames
