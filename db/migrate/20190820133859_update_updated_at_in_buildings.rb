class UpdateUpdatedAtInBuildings < ActiveRecord::Migration[5.2]
  def up
    execute %|update public.facilities_management_buildings set updated_at = now(), status = 'Incomplete', id = gen_random_uuid(), updated_by = 'ADMIN'|
    execute %|update public.facilities_management_buildings SET building_json = jsonb_set(building_json, '{id}', to_json(id::TEXT)::jsonb)|
  end

  def down
    execute "update public.facilities_management_buildings set updated_at = ''"
  end
end
