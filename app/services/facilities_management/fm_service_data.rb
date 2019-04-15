require 'json'
require 'base64'
require 'pg'
class FMServiceData
  def service(email_address, building_id)
    query = "select trim(replace(elem->>'code', '-', '.')) code, elem->>'name' as description from
	(select jsonb_array_elements(building_json->'services') elem from facilities_management_buildings where
		facilities_management_buildings.building_json->>'id' = '" + building_id + "' and
		 facilities_management_buildings.user_id = '" + Base64.encode64(email_address) + "') sub where
     trim(replace(elem->>'code', '-', '.')) not in (
		select v.service_code from fm_uom_values v where
		v.building_id = '" + building_id + "'
		and v.user_id = '" + Base64.encode64(email_address) + "') and
    trim(replace(elem->>'code', '-', '.')) in (select distinct (unnest(service_usage)) from fm_units_of_measurement fuom order by 1) limit 1;"
    ActiveRecord::Base.connection.execute(query)
  rescue StandardError => e
    Rails.logger.warn "Couldn't retrieve service data: #{e}"
  end

  def unset_service_count(email_address, building_id)
    records = service(email_address, building_id)
    records.ntuples
  rescue StandardError => e
    Rails.logger.warn "Couldn't retrieve service data: #{e}"
  end

  # Get any service with an unset unit of measurement value
  # for a particular user and building
  def unit_of_measurement_unset(email_address, building_id)
    # first query for any unit value that is missing and get the details
    result_a = service(email_address, building_id)
    return_data = {}
    return_data['hasService'] = false

    if result_a.ntuples.positive?
      service = result_a[0].to_h
      code = service['code']

      # query for a uom description etc based on the service code
      description = service['description']
      query = "select fuom.title_text, fuom.example_text, fuom.unit_text from fm_units_of_measurement fuom where '" + code + "' in (select(unnest(service_usage)));"
      result_b = ActiveRecord::Base.connection.execute(query)

      if result_b.present?
        # uom_data = result_b[0].to_h
        return_data['hasService'] = true
        return_data['service_code'] = code
        return_data['service_description'] = description
        result_b.each do |uom_data|
          return_data['title_text'] = uom_data['title_text']
          return_data['example_text'] = uom_data['example_text']
          return_data['unit_text'] = uom_data['unit_text']
        end
      end
    end
    return_data
  rescue StandardError => e
    Rails.logger.warn "Couldn't retrieve unit of measurement data: #{e}"
  end

  def add_uom_value(email_address, building_id, service_code, value)
    query = "INSERT INTO fm_uom_values (user_id, service_code, uom_value,building_id)
             VALUES ('" + Base64.encode64(email_address) + "','" + service_code + "','" + value + "','" + building_id + "');"
    ActiveRecord::Base.connection.execute(query)
  rescue StandardError => e
    Rails.logger.warn "Couldn't add unit of measurement data: #{e}"
  end

  # def is_value_required(service_code)
  #   query = "select distinct count(fuom.title_text) from fm_units_of_measurement fuom where '" + service_code + "' in (select(unnest(service_usage)));"
  #   ActiveRecord::Base.connection.execute(query)
  # rescue StandardError => e
  #   Rails.logger.warn "Couldn't retrieve unit of measurement data: #{e}"
  # end
end
