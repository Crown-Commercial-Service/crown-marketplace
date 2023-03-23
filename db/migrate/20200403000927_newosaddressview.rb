class Newosaddressview < ActiveRecord::Migration[5.2]
  # rubocop:disable Metrics/MethodLength, Metrics/BlockLength
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL.squish
            CREATE OR replace VIEW public.os_address_view_2 AS
                 SELECT
               CASE
                   WHEN NULLIF(adds.rm_organisation_name::text, ''::text) IS NULL THEN NULL::character varying
                   ELSE adds.rm_organisation_name
               END AS organisation,
               CASE
                   WHEN btrim((adds.pao_start_number::text || ''::text) || adds.pao_start_suffix::text) = COALESCE(adds.building_name, adds.sub_building_name)::text THEN NULL::text
                   WHEN NULLIF(
                   CASE
                       WHEN NULLIF(adds.sub_building_name::text, ''::text) IS NULL THEN adds.building_name::text
                       ELSE
                       CASE
                           WHEN NULLIF(adds.building_name::text, ''::text) IS NULL THEN adds.sub_building_name::text
                           ELSE adds.sub_building_name::text || ', '::text
                       END || COALESCE(adds.building_name, ''::text::character varying)::text
                   END, ''::text) IS NULL THEN NULL::text
                   ELSE
                   CASE
                       WHEN NULLIF(adds.sub_building_name::text, ''::text) IS NULL THEN adds.building_name::text
                       ELSE
                       CASE
                           WHEN NULLIF(adds.building_name::text, ''::text) IS NULL THEN adds.sub_building_name::text
                           ELSE adds.sub_building_name::text || ', '::text
                       END || COALESCE(adds.building_name, ''::text::character varying)::text
                   END
               END AS building,
               CASE
                   WHEN NULLIF(adds.sao_text::text, ''::text) IS NULL THEN
                   CASE
                       WHEN NULLIF(adds.pao_text::text, ''::text) IS NULL THEN NULL::character varying
                       ELSE adds.pao_text
                   END::text
                   ELSE adds.sao_text::text ||
                   CASE
                       WHEN NULLIF(adds.pao_text::text, ''::text) IS NULL THEN ''::text
                       ELSE ', '::text || adds.pao_text::text
                   END
               END AS addressable_object,
               CASE
                   WHEN NULLIF(btrim((adds.pao_start_number::text || ''::text) || adds.pao_start_suffix::text) || ' '::text, ''::text) IS NULL THEN ''::text
                   ELSE btrim((adds.pao_start_number::text || ''::text) || adds.pao_start_suffix::text) || ' '::text
               END || adds.street_description::text AS street_address,
               CASE
                   WHEN NULLIF(adds.dependent_locality::text, ''::text) IS NULL THEN ''::text
                   ELSE adds.dependent_locality::text || ', '::text
               END ||
               CASE
                   WHEN NULLIF(adds.post_town::text, ''::text) IS NULL THEN adds.town_name
                   ELSE adds.post_town
               END::text AS postal_town,
               CASE
                   WHEN NULLIF(adds.postcode::text, ''::text) IS NULL THEN NULL::character varying
                   ELSE adds.postcode
               END AS postcode,
           adds.postcode_locator,
           NULLIF(adds.sub_building_name::text, ''::text) AS sub_building_name,
           NULLIF(adds.building_name::text, ''::text) AS building_name,
           NULLIF(adds.pao_text::text, ''::text) AS pao_name,
           NULLIF(adds.sao_text::text, ''::text) AS sao_name,
           btrim((adds.pao_start_number::text || ''::text) || adds.pao_start_suffix::text) AS house_number,
           adds.street_description,
           NULLIF(adds.dependent_locality::text, ''::text) AS village,
               CASE
                   WHEN NULLIF(adds.post_town::text, ''::text) IS NULL THEN adds.town_name
                   ELSE adds.post_town
               END AS post_town,
           replace(adds.postcode_locator::text, ' '::text, ''::text) AS formatted_postcode,
           replace(adds.postcode_locator::text, ' '::text, adds.delivery_point_suffix::text) AS building_ref
          FROM os_address adds;
        SQL

        execute <<~SQL.squish
          CREATE OR REPLACE VIEW public.postcode_region_view
          AS
          SELECT nuts.code AS region_code,
             nuts3.name AS region,
             nuts.postcode
            FROM postcodes_nuts_regions nuts
              JOIN nuts_regions nuts3 ON nuts3.code::text = nuts.code::text;
        SQL

        execute <<~SQL.squish
               CREATE OR REPLACE VIEW public.postcode_lookup
               AS
               SELECT ((((
                  CASE
                      WHEN addresses.organisation IS NOT NULL AND NULLIF("position"(addresses.addressable_object, addresses.organisation::text), 0) IS NULL THEN initcap(addresses.organisation::text) || ', '::text
                      ELSE ''::text
                  END ||
                  CASE
                      WHEN addresses.addressable_object IS NOT NULL THEN initcap(addresses.addressable_object) || ', '::text
                      WHEN addresses.building IS NOT NULL THEN initcap(addresses.building) || ', '::text
                      ELSE ''::text
                  END) ||
                  CASE
                      WHEN addresses.street_address IS NOT NULL THEN initcap(addresses.street_address) || ', '::text
                      ELSE initcap(addresses.street_description::text) || ', '::text
                  END) || initcap(addresses.postal_town)) || ''::text) AS summary_line,
                 CASE
               WHEN addresses.organisation IS NOT NULL THEN
                 case when addresses.addressable_object is not null then
                   initcap(addresses.organisation::text) || ', '::text || initcap(addresses.addressable_object)
                 else
                   initcap(addresses.organisation::text) || ''::text
                 end
                     WHEN addresses.addressable_object is not null then initcap(addresses.addressable_object) || ''::text
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
               WHEN addresses.addressable_object is not null or addresses.organisation IS NOT NULL then
                 CASE
                   WHEN addresses.street_address IS NOT NULL THEN initcap(addresses.street_address) || ''::text
                   ELSE initcap(addresses.street_description::text) || ''::text
                 END
               ELSE
                 ''::text
                 END AS address_line_2,
             initcap(addresses.postal_town) AS address_town,
             addresses.postcode_locator AS address_postcode,
             initcap(regions.region::text) AS address_region,
             regions.region_code AS address_region_code
            FROM os_address_view_2 addresses
          LEFT outer JOIN postcode_region_view regions ON regions.postcode::text = replace(addresses.postcode_locator::text, ' '::text, ''::text);
        SQL
      end

      dir.down do
        execute <<~SQL.squish
          DROP VIEW IF EXISTS public.postcode_lookup;
          DROP VIEW IF EXISTS public.postcode_region_view;
          DROP VIEW IF EXISTS public.os_address_view_2;
        SQL
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/BlockLength
end
