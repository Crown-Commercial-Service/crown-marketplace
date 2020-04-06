class Newosaddressview < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
          CREATE OR REPLACE VIEW public.os_address_view_2 AS
                    SELECT
            case when NULLIF(adds.rm_organisation_name, ''::text) is null then null else adds.rm_organisation_name end as Organisation
            , NULLIF(case when NULLIF( adds.sub_building_name, ''::text) is null then '' else (adds.sub_building_name || ', ') end || adds.building_name, ''::text) as BuildingName
            , BTRIM(adds.pao_start_number::text || ''::text || adds.pao_start_suffix::text) || ' ' || adds.street_description as StreetAddress
            , case when NULLIF(adds.dependent_locality, ''::text) is null then '' else (adds.dependent_locality || ', ') end || adds.post_town as PostalTown
            , adds.postcode
            , NULLIF(adds.sub_building_name, ''::text) as sub_building_name
            , NULLIF(adds.building_name, ''::text) as building_name
            , btrim(adds.pao_start_number::text || ''::text || adds.pao_start_suffix::text) as HouseNumber
            , adds.street_description
            , NULLIF(adds.dependent_locality, ''::text) AS village
            , adds.post_town
            , replace(adds.postcode::text, ' '::text, ''::text) AS formatted_postcode
            , replace(adds.postcode::text, ' '::text, adds.delivery_point_suffix::text) AS building_ref
            , region_code
            , region
          FROM public.os_address adds
              left outer join ( select nuts.code as region_code, nuts3.name as region, nuts.postcode
          				  from postcodes_nuts_regions nuts inner join nuts_regions nuts3
          				on nuts3.code = nuts.code) as regions on regions.postcode = replace(adds.postcode::text, ' '::text, '')
          	order by postcode;
        SQL
      end

      dir.down do
        execute <<~SQL
          DROP VIEW IF EXISTS public.os_address_view_2
        SQL
      end
    end
  end
end
