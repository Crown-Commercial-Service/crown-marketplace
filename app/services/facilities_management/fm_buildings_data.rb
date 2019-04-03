require 'json'
require 'base64'
class FMBuildingData
  def initialize
    create_facilities_management_buildings_table
  end

  def create_facilities_management_buildings_table
    query = 'CREATE TABLE if not exists public.facilities_management_buildings
            (
                user_id character varying COLLATE pg_catalog."default" NOT NULL,
                building_json json NOT NULL
            );'
    ActiveRecord::Base.connection.execute(query)
    query = 'CREATE INDEX if not exists facilities_management_buildings_user_id_idx
    ON public.facilities_management_buildings USING btree
    (user_id COLLATE pg_catalog."default");'
    ActiveRecord::Base.connection.execute(query)
  rescue StandardError => e
    Rails.logger.warn "Couldn't create the facilities_management_buildings table: #{e}"
  end

  def save_building(email_address, building)
    query = "insert into facilities_management_buildings values('" + Base64.encode64(email_address) + "', '" + building + "')"
    ActiveRecord::Base.connection.execute(query)
  rescue StandardError => e
    Rails.logger.warn "Couldn't save building: #{e}"
    true
  end

  def update_building(email_address, id, building)
    query = "update facilities_management_buildings set building_json = '" + building + "'" \
            " where user_id = '" + Base64.encode64(email_address) + "' and building_json ->> 'id' = '" + id + "'"
    ActiveRecord::Base.connection.execute(query)
  rescue StandardError => e
    Rails.logger.warn "Couldn't update building: #{e}"
  end

  def get_building_data(email_address)
    ActiveRecord::Base.include_root_in_json = false
    query = "select building_json as building from facilities_management_buildings where user_id = '" + Base64.encode64(email_address) + "'"
    result = ActiveRecord::Base.connection.execute(query)
    JSON.parse(result.to_json)
  rescue StandardError => e
    Rails.logger.warn "Couldn't get building data: #{e}"
  end

  def get_count_of_buildings(email_address)
    query = "select count(*) as record_count from facilities_management_buildings where user_id = '" + Base64.encode64(email_address) + "'"
    result = ActiveRecord::Base.connection.execute(query)
    result[0]['record_count']
  rescue StandardError => e
    Rails.logger.warn "Couldn't get count of buildings: #{e}"
  end
end
