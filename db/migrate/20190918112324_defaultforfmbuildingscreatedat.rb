class Defaultforfmbuildingscreatedat < ActiveRecord::Migration[5.2]
  def up
    change_column_null :facilities_management_buildings, :created_at, true
    execute 'ALTER TABLE public.facilities_management_buildings ALTER COLUMN created_at SET DEFAULT now();'
    execute 'ALTER TABLE public.facilities_management_buildings ALTER COLUMN updated_at SET DEFAULT now();'
  end

  def down
    change_column_null :facilities_management_buildings, :created_at, false
    execute 'ALTER TABLE public.facilities_management_buildings ALTER COLUMN created_at SET DEFAULT now();'
    execute 'ALTER TABLE public.facilities_management_buildings ALTER COLUMN updated_at SET DEFAULT now();'
  end
end
