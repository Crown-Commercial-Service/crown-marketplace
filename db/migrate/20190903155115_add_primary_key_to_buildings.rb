class AddPrimaryKeyToBuildings < ActiveRecord::Migration[5.2]
  def change
    execute "ALTER TABLE public.facilities_management_buildings ADD CONSTRAINT facilities_management_buildings_pk PRIMARY KEY (id);"
  end
end
