class UpdateOsAddressView < ActiveRecord::Migration[5.2]
  def up
    execute "create or replace view os_address_view as select ((adds.pao_start_number || adds.pao_start_suffix::text) || ' '::text) || adds.street_description::text as add1, adds.town_name as village, adds.post_town, adds.administrative_area as county, adds.postcode, replace(adds.postcode::text, ' '::text, ''::text) as formated_postcode, replace(adds.postcode::text, ' '::text, adds.delivery_point_suffix::text) as building_ref from os_address adds where ((adds.pao_start_number || adds.pao_start_suffix::text) || adds.street_description::text) is not null and adds.post_town is not null order by adds.pao_start_number, adds.street_description;"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
