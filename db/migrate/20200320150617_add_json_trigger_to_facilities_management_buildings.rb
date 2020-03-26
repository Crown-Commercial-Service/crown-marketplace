class AddJsonTriggerToFacilitiesManagementBuildings < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        create_trigger_functions
        create_triggers
      end

      dir.down do
        execute <<~SQL
          DROP trigger IF EXISTS create_building_json ON public.facilities_management_buildings;
          DROP TRIGGER IF EXISTS create_building_json_on_update ON public.facilities_management_buildings;
          DROP trigger IF EXISTS insert_building_from_json ON public.facilities_management_buildings;
          DROP trigger IF EXISTS update_building_from_json ON public.facilities_management_buildings;
          DROP trigger IF EXISTS update_building_status ON public.facilities_management_buildings;
          drop function IF EXISTS public.build_building_json;
          DROP function IF EXISTS public.extract_building_row_from_json;
          drop function IF EXISTS public.update_building_status;
        SQL
      end
    end
  end

  def create_trigger_functions
    execute <<~SQL
      CREATE FUNCTION public.update_building_status()
          RETURNS trigger
          LANGUAGE 'plpgsql'
          COST 100
          VOLATILE NOT LEAKPROOF
      AS $BODY$
      DECLARE
        new_status bool := false;
      BEGIN
        new_status := COALESCE(NEW.building_name,'') <> '' and
                      COALESCE(NEW.gia,-1) <> -1 and
                      COALESCE(NEW.region,'') <> '' and
                      COALESCE(NEW.building_type,'') <> '' and
                      COALESCE(NEW.security_type,'') <> '' and
                      COALESCE(NEW.building_ref,'') <> '';
         NEW.status := CASE WHEN new_status = true then 'Ready' else 'Incomplete' end;
         return new;
      END;
      $BODY$;

      CREATE FUNCTION public.build_building_json()
          RETURNS trigger
          LANGUAGE 'plpgsql'
          COST 100
          VOLATILE NOT LEAKPROOF
      AS $BODY$	begin
	        NEW.building_json := json_build_object(
                      'id', NEW.id,
                      'gia', COALESCE(NEW.gia,null),
                      'name', COALESCE(NEW.building_name,''),
                      'region', COALESCE(NEW.region,''),
                      'address', json_build_object(
                        'building-ref', COALESCE(NEW.building_ref,''),
                        'fm-address-town', COALESCE(NEW.address_town,''),
                        'fm-address-county', COALESCE(NEW.address_county,''),
                        'fm-address-line-1', COALESCE(NEW.address_line_1,''),
                        'fm-address-line-2', COALESCE(NEW.address_line_2,''),
                        'fm-address-region', COALESCE(NEW.address_region,''),
                        'fm-address-postcode', COALESCE(NEW.address_postcode,''),
                        'fm-address-region-code', COALESCE(NEW.address_region_code,'')),
                      'description', COALESCE(NEW.description,''),
                      'building-ref', COALESCE(NEW.building_ref,''),
                      'building-type', COALESCE(NEW.building_type,''),
                      'security_type', COALESCE(NEW.security_type,'')
                    );
               return NEW;
        END;
      $BODY$;
       ALTER FUNCTION public.build_building_json()
          OWNER TO postgres;
       CREATE OR REPLACE FUNCTION public.extract_building_row_from_json()
       RETURNS trigger
       LANGUAGE plpgsql
      AS $function$
        begin
          NEW.gia := NEW.building_json ->> 'gia';
          NEW.building_name := NEW.building_json ->> 'name';
          NEW.description := NEW.building_json ->> 'description';
          NEW.region := NEW.building_json ->> 'region';
          NEW.building_ref := NEW.building_json ->> 'building-ref';
          NEW.building_type := NEW.building_json ->> 'building-type';
          NEW.security_type := NEW.building_json ->> 'security-type';
          NEW.address_town := (NEW.building_json -> 'address')::jsonb ->> 'fm-address-town';
          NEW.address_county := (NEW.building_json -> 'address')::jsonb ->> 'fm-address-county';
          NEW.address_line_1 := (NEW.building_json -> 'address')::jsonb ->> 'fm-address-line-1';
          NEW.address_line_2 := (NEW.building_json -> 'address')::jsonb ->> 'fm-address-line-2';
          NEW.address_region := (NEW.building_json -> 'address')::jsonb ->> 'fm-address-region';
          NEW.address_postcode := (NEW.building_json -> 'address')::jsonb ->> 'fm-address-postcode';
          NEW.address_region_code := (NEW.building_json -> 'address')::jsonb ->> 'fm-address-region-code';
           return NEW;
        END;
      $function$;
    SQL
  end

  def create_triggers
    execute <<~SQL
          DROP TRIGGER IF EXISTS create_building_json ON public.facilities_management_buildings;
      create trigger create_building_json
          before insert
          on public.facilities_management_buildings
          for each row
          when ( NEW.building_json = '"{}"' OR COALESCE(NEW.building_json, '{}'::jsonb) = '{}'::jsonb)
          execute procedure public.build_building_json();
       DROP TRIGGER IF EXISTS create_building_json_on_update ON public.facilities_management_buildings;
      create trigger create_building_json_on_update
          before update of status, updated_by, building_ref, building_name, description, gia, region, building_type, security_type, address_town, address_county, address_line_1, address_line_2, address_postcode, address_region, address_region_code
          on public.facilities_management_buildings
          for each row
          execute procedure public.build_building_json();
       DROP TRIGGER IF EXISTS update_building_status ON public.facilities_management_buildings;
      create trigger update_building_status
          before insert or update
          on public.facilities_management_buildings
          for each row
          execute procedure public.update_building_status();
       DROP trigger IF EXISTS update_building_from_json ON public.facilities_management_buildings;
      create trigger update_building_from_json
          before update of building_json
          on public.facilities_management_buildings
          for each row
          execute procedure public.extract_building_row_from_json();
       DROP trigger IF EXISTS insert_building_from_json ON public.facilities_management_buildings;
      create trigger insert_building_from_json
          before insert
          on public.facilities_management_buildings
          for each row
          when (NEW.building_json <> '"{}"' OR COALESCE(NEW.building_json, '{}'::jsonb) <> '{}'::jsonb)
          execute procedure public.extract_building_row_from_json();
    SQL
  end
end
