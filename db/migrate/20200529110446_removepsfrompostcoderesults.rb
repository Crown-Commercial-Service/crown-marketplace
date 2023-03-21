class Removepsfrompostcoderesults < ActiveRecord::Migration[5.2]
  # rubocop:disable Metrics/MethodLength, Metrics/BlockLength
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL.squish
          DROP VIEW IF EXISTS public.postcode_lookup cascade;
          DROP VIEW IF EXISTS public.os_address_view_2 cascade;
        SQL

        execute <<~SQL.squish
          create or replace
          view public.os_address_view_2 as
          select
          	case
          		when nullif(adds.sub_building_name::text, ''::text) is null
          		and nullif(adds.building_name::text, ''::text) is null
          		and nullif(adds.pao_text::text, ''::text) is not null then adds.pao_text::text || ''::text
          		when btrim((adds.pao_start_number::text || ''::text) || adds.pao_start_suffix::text) = coalesce(adds.building_name, adds.sub_building_name)::text then null::text
          		when nullif( case when nullif(adds.sub_building_name::text, ''::text) is null then adds.building_name::text else case when nullif(adds.building_name::text, ''::text) is null then adds.sub_building_name::text else adds.sub_building_name::text || ', '::text end || coalesce(adds.building_name, ''::text::character varying)::text end, ''::text) is null then null::text
          		else
          		case
          			when nullif(adds.sub_building_name::text, ''::text) is null then adds.building_name::text
          			else
          			case
          				when nullif(adds.building_name::text, ''::text) is null then adds.sub_building_name::text
          				else adds.sub_building_name::text || ', '::text end || coalesce(adds.building_name, ''::text::character varying)::text end end as building,
          				case
          					when nullif(btrim((adds.pao_start_number::text || ''::text) || adds.pao_start_suffix::text) || ' '::text, ''::text) is null then ''::text
          					else btrim((adds.pao_start_number::text || ''::text) || adds.pao_start_suffix::text) || ' '::text end || adds.street_description::text as street_address,
          					case
          						when nullif(adds.dependent_locality::text, ''::text) is null then ''::text
          						else adds.dependent_locality::text || ', '::text end ||
          						case
          							when nullif(adds.post_town::text, ''::text) is null then adds.town_name
          							else adds.post_town end::text as postal_town,
          							adds.postcode_locator,
          							nullif(adds.sub_building_name::text, ''::text) as sub_building_name,
          							nullif(adds.building_name::text, ''::text) as building_name,
          							nullif(adds.pao_text::text, ''::text) as pao_name,
          							nullif(adds.sao_text::text, ''::text) as sao_name,
          							btrim((adds.pao_start_number::text || ''::text) || adds.pao_start_suffix::text) as house_number,
          							adds.street_description,
          							nullif(adds.dependent_locality::text, ''::text) as village,
          							case
          								when nullif(adds.post_town::text, ''::text) is null then adds.town_name
          								else adds.post_town end as post_town,
          								replace(adds.postcode_locator::text, ' '::text, ''::text) as formatted_postcode,
          								replace(adds.postcode_locator::text, ' '::text, adds.delivery_point_suffix::text) as building_ref,
          								adds.uprn,
          								adds.class
          							from
          								os_address adds
          							where
          								(adds.class::text !~~ 'O%'::text
          								or adds.class::text ~~ 'OE%'::text
          								or adds.class::text ~~ 'OH%'::text
          								or adds.class::text ~~ 'ON%'::text
          								or adds.class::text ~~ 'OP%'::text
          								or adds.class::text ~~ 'OS%'::text)
          								and adds.class::text !~~ 'U%'::text
          								and adds.class::text !~~ 'CH%'::text
          								and adds.class::text !~~ 'CZ%'::text
          								and adds.class::text !~~ 'PS'::text
          								and adds.class::text !~~ 'CU11%'::text;
        SQL

        # postcode_lookup is unchanged in this migration
        execute <<~SQL.squish
          CREATE VIEW postcode_lookup
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
          create or replace
          view public.os_address_view_2 as
          select
          	case
          		when nullif(adds.sub_building_name::text, ''::text) is null
          		and nullif(adds.building_name::text, ''::text) is null
          		and nullif(adds.pao_text::text, ''::text) is not null then adds.pao_text::text || ''::text
          		when btrim((adds.pao_start_number::text || ''::text) || adds.pao_start_suffix::text) = coalesce(adds.building_name, adds.sub_building_name)::text then null::text
          		when nullif( case when nullif(adds.sub_building_name::text, ''::text) is null then adds.building_name::text else case when nullif(adds.building_name::text, ''::text) is null then adds.sub_building_name::text else adds.sub_building_name::text || ', '::text end || coalesce(adds.building_name, ''::text::character varying)::text end, ''::text) is null then null::text
          		else
          		case
          			when nullif(adds.sub_building_name::text, ''::text) is null then adds.building_name::text
          			else
          			case
          				when nullif(adds.building_name::text, ''::text) is null then adds.sub_building_name::text
          				else adds.sub_building_name::text || ', '::text end || coalesce(adds.building_name, ''::text::character varying)::text end end as building,
          				case
          					when nullif(btrim((adds.pao_start_number::text || ''::text) || adds.pao_start_suffix::text) || ' '::text, ''::text) is null then ''::text
          					else btrim((adds.pao_start_number::text || ''::text) || adds.pao_start_suffix::text) || ' '::text end || adds.street_description::text as street_address,
          					case
          						when nullif(adds.dependent_locality::text, ''::text) is null then ''::text
          						else adds.dependent_locality::text || ', '::text end ||
          						case
          							when nullif(adds.post_town::text, ''::text) is null then adds.town_name
          							else adds.post_town end::text as postal_town,
          							adds.postcode_locator,
          							nullif(adds.sub_building_name::text, ''::text) as sub_building_name,
          							nullif(adds.building_name::text, ''::text) as building_name,
          							nullif(adds.pao_text::text, ''::text) as pao_name,
          							nullif(adds.sao_text::text, ''::text) as sao_name,
          							btrim((adds.pao_start_number::text || ''::text) || adds.pao_start_suffix::text) as house_number,
          							adds.street_description,
          							nullif(adds.dependent_locality::text, ''::text) as village,
          							case
          								when nullif(adds.post_town::text, ''::text) is null then adds.town_name
          								else adds.post_town end as post_town,
          								replace(adds.postcode_locator::text, ' '::text, ''::text) as formatted_postcode,
          								replace(adds.postcode_locator::text, ' '::text, adds.delivery_point_suffix::text) as building_ref,
          								adds.uprn,
          								adds.class
          							from
          								os_address adds
          							where
          								(adds.class::text !~~ 'O%'::text
          								or adds.class::text ~~ 'OE%'::text
          								or adds.class::text ~~ 'OH%'::text
          								or adds.class::text ~~ 'ON%'::text
          								or adds.class::text ~~ 'OP%'::text
          								or adds.class::text ~~ 'OS%'::text)
          								and adds.class::text !~~ 'U%'::text
          								and adds.class::text !~~ 'CH%'::text
          								and adds.class::text !~~ 'CZ%'::text
          								and adds.class::text !~~ 'P%'::text
          								and adds.class::text !~~ 'CU11%'::text;
        SQL

        # postcode_lookup is unchanged in this migration
        execute <<~SQL.squish
          CREATE VIEW postcode_lookup
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
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/BlockLength
end
