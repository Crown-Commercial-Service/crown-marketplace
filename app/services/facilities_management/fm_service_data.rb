require 'json'
require 'base64'
class FMServiceData

  # Get any service with an unset unit of measurement value
  # for a particular user and building
  def uom_unset (email_address, building_id)
    # first query for any unit value that is missing and get the details
    return_data = {}
    query = "select trim(replace(elem->>'code', '-', '.')) code, elem->>'name' as description
      from ( select jsonb_array_elements(building_json->'services') elem
      from
      facilities_management_buildings
      where
      building_json->>'id' = '" + building_id + "' and user_id = '" + Base64.encode64(email_address) + "'
      and building_json->'services'->>'uom_value' is null) sub limit 1;"
    result_a = ActiveRecord::Base.connection.execute(query)

    if result_a.present?
      service = result_a.to_hash
      code = service['code']
      return_data = {}

      if code.present?
        # query for a uom description etc based on the service code
        description = service['description']
        query = "select fuom.title_text, fuom.example_text, fuom.unit_text from fm_units_of_measurement fuom where '" + code + "' in (select(unnest(service_usage)));"
        result_b = ActiveRecord::Base.connection.execute(query)

        if result_b.present?
          uom_data = result_b.to_hash
          return_data['service_code'] = code
          return_data['service_description'] = description
          return_data['title_text'] = uom_data['title_text']
          return_data['example_text'] = uom['example_text']
          return_data['unit_text'] = uom['unit_text']
        end
      end
    end
    return_data
  rescue StandardError => e
    Rails.logger.warn "Couldn't retrieve unit of measurement: #{e}"
  end
end
