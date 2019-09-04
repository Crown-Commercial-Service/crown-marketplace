class AddPrimaryKeyToBuildings < ActiveRecord::Migration[5.2]
  def up
    execute 'ALTER TABLE public.facilities_management_buildings ADD CONSTRAINT facilities_management_buildings_pk PRIMARY KEY (id);'
  end

  def down
    execute 'ALTER TABLE public.facilities_management_buildings DROP CONSTRAINT facilities_management_buildings_pk;'
  end
end
