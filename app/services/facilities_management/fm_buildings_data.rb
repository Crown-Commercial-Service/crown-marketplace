require 'json'
class FMBuildingData
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