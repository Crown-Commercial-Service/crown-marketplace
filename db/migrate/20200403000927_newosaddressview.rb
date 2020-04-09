class Newosaddressview < ActiveRecord::Migration[5.2]
  # rubocop:disable Metrics/MethodLength, BlockLength
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
          CREATE OR replace VIEW public.os_address_view_2 AS
          SELECT
                 CASE
                        WHEN Nullif(adds.rm_organisation_name::text, ''::text) IS NULL THEN NULL::CHARACTER varying
                        ELSE adds.rm_organisation_name
                 END AS organisation,
                 CASE
                    when (btrim((adds.pao_start_number::text
                                || ''::text)
                                || adds.pao_start_suffix::text)) = coalesce(adds.building_name, adds.sub_building_name) then
                                null
                        WHEN nullif((
                               CASE
                                      WHEN nullif(adds.sub_building_name::text, ''::text) IS NULL THEN adds.building_name
                                      ELSE
                                             CASE
                                                    WHEN nullif(adds.building_name, ''::text) IS NULL THEN adds.sub_building_name
                                                    ELSE adds.sub_building_name
                                                                  || ', '
                                             END
                                                    || coalesce(adds.building_name,''::text)
                               END), ''::text) IS NULL THEN NULL
                        ELSE (
                               CASE
                                      WHEN nullif(adds.sub_building_name::text, ''::text) IS NULL THEN adds.building_name
                                      ELSE
                                             CASE
                                                    WHEN nullif(adds.building_name, ''::text) IS NULL THEN adds.sub_building_name
                                                    ELSE adds.sub_building_name
                                                                  || ', '
                                             END
                                                    || coalesce(adds.building_name,''::text)
                               END)
                 END AS building,
                 CASE
                        WHEN nullif((btrim((adds.pao_start_number::text
                                      || ''::text)
                                      || adds.pao_start_suffix::text)
                                      || ' '::text), ''::text) IS NULL THEN ''
                        ELSE (btrim((adds.pao_start_number::text
                                      || ''::text)
                                      || adds.pao_start_suffix::text)
                                      || ' '::text)
                 END
                        || adds.street_description::text AS street_address,
                 CASE
                        WHEN nullif(adds.dependent_locality::text, ''::text) IS NULL THEN ''::text
                        ELSE adds.dependent_locality::text
                                      || ', '::text
                 END
                        || adds.post_town::text AS postal_town,
                 adds.postcode,
                 adds.postcode_locator,
                 nullif(adds.sub_building_name::text, ''::text) AS sub_building_name,
                 nullif(adds.building_name::text, ''::text)     AS building_name,
                 btrim((adds.pao_start_number::text
                        || ''::text)
                        || adds.pao_start_suffix::text) AS house_number,
                 adds.street_description,
                 nullif(adds.dependent_locality::text, ''::text) AS village,
                 adds.post_town,
                 replace(adds.postcode::text, ' '::text, ''::text)                         AS formatted_postcode,
                 replace(adds.postcode::text, ' '::text, adds.delivery_point_suffix::text) AS building_ref
          FROM   os_address adds;
        SQL

        execute <<~SQL
          CREATE OR REPLACE VIEW public.postcode_region_view
          AS
          SELECT nuts.code AS region_code,
             nuts3.name AS region,
             nuts.postcode
            FROM postcodes_nuts_regions nuts
              JOIN nuts_regions nuts3 ON nuts3.code::text = nuts.code::text;
        SQL

        execute <<~SQL
          CREATE OR REPLACE VIEW public.postcode_lookup
          AS
          SELECT ((((
                 CASE
                     WHEN addresses.organisation IS NOT NULL THEN initcap(addresses.organisation::text) || ', '::text
                     ELSE ''::text
                 END ||
                 CASE
                     WHEN addresses.building IS NOT NULL THEN initcap(addresses.building) || ', '::text
                     ELSE ''::text
                 END) ||
                 CASE
                     WHEN addresses.street_address IS NOT NULL THEN initcap(addresses.street_address) || ', '::text
                     ELSE initcap(addresses.street_description::text) || ', '::text
                 END) || initcap(addresses.postal_town)) || ''::text) || ', '::text || regions.region AS summary_line,
                 CASE
                     WHEN addresses.organisation IS NOT NULL THEN initcap(addresses.organisation::text) || ''::text
                     ELSE
                       CASE
                           WHEN addresses.building IS NOT NULL THEN initcap(addresses.building) || ', '::text
                           ELSE ''::text
                       END ||
                       CASE
                           WHEN addresses.street_address IS NOT NULL THEN initcap(addresses.street_address) || ''::text
                           ELSE initcap(addresses.street_description::text) || ''::text
                       END
                 END AS address_line_1,
                 CASE
                     WHEN addresses.organisation IS NOT NULL THEN
                     CASE
                         WHEN addresses.building IS NOT NULL THEN initcap(addresses.building) || ''::text
                         ELSE ''::text
                     END ||
                     CASE
                         WHEN addresses.street_address IS NOT NULL THEN initcap(addresses.street_address) || ''::text
                         ELSE initcap(addresses.street_description::text) || ''::text
                     END
                     ELSE ''::text
                 END AS address_line_2,
             addresses.postcode AS address_postcode,
             initcap(addresses.postal_town) AS address_town,
             initcap(regions.region::text) AS address_region,
             regions.region_code AS address_region_code
            FROM os_address_view_2 addresses
              LEFT JOIN postcode_region_view regions ON regions.postcode::text = replace(addresses.postcode::text, ' '::text, ''::text);
        SQL
      end

      dir.down do
        execute <<~SQL
          DROP VIEW IF EXISTS public.postcode_lookup;
          DROP VIEW IF EXISTS public.postcode_region_view;
          DROP VIEW IF EXISTS public.os_address_view_2;
        SQL
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, BlockLength
end
