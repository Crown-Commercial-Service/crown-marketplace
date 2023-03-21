class Updatepostcodeviews < ActiveRecord::Migration[5.2]
  # rubocop:disable Metrics/MethodLength, Metrics/BlockLength
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL.squish
          DROP VIEW IF EXISTS public.postcode_lookup;
          DROP VIEW IF EXISTS public.os_address_view_2;
        SQL

        execute <<~SQL.squish
           CREATE or replace VIEW os_address_view_2
                      (building, street_address, postal_town, postcode_locator, sub_building_name, building_name, pao_name,
                       sao_name, house_number, street_description, village, post_town, formatted_postcode, building_ref, uprn,
                       class)
          AS
          SELECT CASE
                     WHEN NULLIF(adds.sub_building_name::TEXT, ''::TEXT) IS NULL AND
                          NULLIF(adds.building_name::TEXT, ''::TEXT) IS NULL AND NULLIF(adds.pao_text::TEXT, ''::TEXT) IS NOT NULL
                         THEN adds.pao_text::TEXT || ''::TEXT
                     WHEN btrim((adds.pao_start_number::TEXT || ''::TEXT) || adds.pao_start_suffix::TEXT) =
                          COALESCE(adds.building_name, adds.sub_building_name)::TEXT THEN NULL::TEXT
                     WHEN NULLIF(
                             CASE
                                 WHEN NULLIF(adds.sub_building_name::TEXT, ''::TEXT) IS NULL THEN adds.building_name::TEXT
                                 ELSE
                                         CASE
                                             WHEN NULLIF(adds.building_name::TEXT, ''::TEXT) IS NULL THEN adds.sub_building_name::TEXT
                                             ELSE adds.sub_building_name::TEXT || ', '::TEXT
                                             END || COALESCE(adds.building_name, ''::TEXT::CHARACTER VARYING)::TEXT
                                 END, ''::TEXT) IS NULL THEN NULL::TEXT
                     ELSE
                         CASE
                             WHEN NULLIF(adds.sub_building_name::TEXT, ''::TEXT) IS NULL THEN adds.building_name::TEXT
                             ELSE
                                     CASE
                                         WHEN NULLIF(adds.building_name::TEXT, ''::TEXT) IS NULL THEN adds.sub_building_name::TEXT
                                         ELSE adds.sub_building_name::TEXT || ', '::TEXT
                                         END || COALESCE(adds.building_name, ''::TEXT::CHARACTER VARYING)::TEXT
                             END
              END                                                                                  AS building
               , CASE
                     WHEN NULLIF(btrim((adds.pao_start_number::TEXT || ''::TEXT) || adds.pao_start_suffix::TEXT) || ' '::TEXT,
                                 ''::TEXT) IS NULL THEN ''::TEXT
                     ELSE btrim((adds.pao_start_number::TEXT || ''::TEXT) || adds.pao_start_suffix::TEXT) || ' '::TEXT
                     END || adds.street_description::TEXT                                          AS street_address
               , CASE
                     WHEN NULLIF(adds.dependent_locality::TEXT, ''::TEXT) IS NULL THEN ''::TEXT
                     ELSE adds.dependent_locality::TEXT || ', '::TEXT
                     END ||
                 CASE
                     WHEN NULLIF(adds.post_town::TEXT, ''::TEXT) IS NULL THEN adds.town_name
                     ELSE adds.post_town
                     END::TEXT                                                                     AS postal_town
               , adds.postcode_locator
               , NULLIF(adds.sub_building_name::TEXT, ''::TEXT)                                    AS sub_building_name
               , NULLIF(adds.building_name::TEXT, ''::TEXT)                                        AS building_name
               , NULLIF(adds.pao_text::TEXT, ''::TEXT)                                             AS pao_name
               , NULLIF(adds.sao_text::TEXT, ''::TEXT)                                             AS sao_name
               , btrim((adds.pao_start_number::TEXT || ''::TEXT) || adds.pao_start_suffix::TEXT)   AS house_number
               , adds.street_description
               , NULLIF(adds.dependent_locality::TEXT, ''::TEXT)                                   AS village
               , CASE
                     WHEN NULLIF(adds.post_town::TEXT, ''::TEXT) IS NULL THEN adds.town_name
                     ELSE adds.post_town
              END                                                                                  AS post_town
               , replace(adds.postcode_locator::TEXT, ' '::TEXT, ''::TEXT)                         AS formatted_postcode
               , replace(adds.postcode_locator::TEXT, ' '::TEXT, adds.delivery_point_suffix::TEXT) AS building_ref
               , adds.uprn
               , adds.class
              FROM os_address adds
              WHERE (adds.class::TEXT !~~ 'O%'::TEXT OR adds.class::TEXT ~~ 'OE%'::TEXT OR adds.class::TEXT ~~ 'OH%'::TEXT OR
                     adds.class::TEXT ~~ 'ON%'::TEXT OR adds.class::TEXT ~~ 'OP%'::TEXT OR adds.class::TEXT ~~ 'OS%'::TEXT)
                AND adds.class::TEXT !~~ 'U%'::TEXT
                AND adds.class::TEXT !~~ 'CH%'::TEXT
                AND adds.class::TEXT !~~ 'CZ%'::TEXT
                AND adds.class::TEXT !~~ 'P%'::TEXT
                AND adds.class::TEXT !~~ 'CU11%'::TEXT;
        SQL

        execute <<~SQL.squish
          CREATE or replace VIEW postcode_lookup
                      (summary_line, address_line_1, address_line_2, address_town, address_postcode, address_region,
                       address_region_code) AS
          SELECT DISTINCT ((
                                   CASE
                                       WHEN addresses.building IS NOT NULL THEN initcap(addresses.building) || ', '::TEXT
                                       ELSE ''::TEXT
                                       END ||
                                   CASE
                                       WHEN addresses.street_address IS NOT NULL THEN initcap(addresses.street_address) || ', '::TEXT
                                       ELSE initcap(addresses.street_description::TEXT) || ', '::TEXT
                                       END) || initcap(addresses.postal_town)) || ''::TEXT AS summary_line
                        , CASE
                              WHEN addresses.building IS NOT NULL THEN initcap(addresses.building)
                              WHEN addresses.street_address IS NOT NULL THEN initcap(addresses.street_address) || ''::TEXT
                              ELSE initcap(addresses.street_description::TEXT) || ''::TEXT
              END                                                                          AS address_line_1
                        , CASE
                              WHEN addresses.building IS NOT NULL AND addresses.street_address IS NOT NULL
                                  THEN initcap(addresses.street_address) || ''::TEXT
                              WHEN addresses.building IS NOT NULL THEN initcap(addresses.street_description::TEXT) || ''::TEXT
                              ELSE NULL::TEXT
              END                                                                          AS address_line_2
                        , initcap(addresses.postal_town)                                   AS address_town
                        , addresses.postcode_locator                                       AS address_postcode
                        , initcap(regions.region::TEXT)                                    AS address_region
                        , regions.region_code                                              AS address_region_code
              FROM os_address_view_2              addresses
                   LEFT JOIN postcode_region_view regions
                             ON regions.postcode::TEXT = replace(addresses.postcode_locator::TEXT, ' '::TEXT, ''::TEXT);
        SQL
      end

      dir.down do
        execute <<~SQL.squish
          DROP VIEW IF EXISTS public.postcode_lookup;
          DROP VIEW IF EXISTS public.os_address_view_2;
        SQL

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
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/BlockLength
end
