require 'json'
class FMBuildingData

  def create_facilities_management_buildings_table

    query = 'CREATE TABLE if not exists public.facilities_management_buildings
            (
                email_address character varying COLLATE pg_catalog."default" NOT NULL,
                building_json json NOT NULL
            );'
    ActiveRecord::Base.connection.execute(query)

    query = 'DROP INDEX public.facilities_management_buildings_email_address_idx;'
    ActiveRecord::Base.connection.execute(query)

    query = 'CREATE INDEX facilities_management_buildings_email_address_idx
    ON public.facilities_management_buildings USING btree
    (email_address COLLATE pg_catalog."default");'

    ActiveRecord::Base.connection.execute(query)
  end

  def save_building(email_address, building)
    query = "insert into facilities_management_buildings values('" + email_address + "', '" + building + "')"
    ActiveRecord::Base.connection.execute(query)
    true
  end

  def get_building_data(email_address)
    ActiveRecord::Base.include_root_in_json = false
    query = "select building_json as building from facilities_management_buildings where email_address = '" + email_address + "'"
    result = ActiveRecord::Base.connection.execute(query)
    JSON.parse(result.to_json)
  end

  def get_count_of_buildings(email_address)
    query = "select count(*) as record_count from facilities_management_buildings where email_address = '" + email_address + "'"
    result = ActiveRecord::Base.connection.execute(query)
    result[0]['record_count']
  end
end
