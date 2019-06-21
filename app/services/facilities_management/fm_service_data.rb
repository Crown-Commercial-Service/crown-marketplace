require 'json'
require 'base64'
require 'pg'
class FMServiceData
  def service(email_address, building_id)
    Rails.logger.info '==> FMServiceData.service()'
    query = "select trim(replace(subcode, '-', '.')) as code, subname as name from (SELECT jsonb_array_elements(building_json->'services') ->>'code' as subcode,
jsonb_array_elements(building_json->'services') ->>'name' as subname
  FROM facilities_management_buildings where facilities_management_buildings.building_json->>'id' = '" + building_id + "' and
		 facilities_management_buildings.user_id = '" + Base64.encode64(email_address) + "') sub
where trim(replace(subcode, '-', '.')) not in (select v.service_code from fm_uom_values v where v.building_id = '" + building_id + "' and
		 v.user_id = '" + Base64.encode64(email_address) + "') and
    trim(replace(subcode, '-', '.')) in (select distinct (unnest(service_usage)) from fm_units_of_measurement fuom order by 1) limit 1;"
    ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query(query) }
  rescue StandardError => e
    Rails.logger.warn "Couldn't retrieve service data: #{e}"
  end

  def unset_service_count(email_address, building_id)
    Rails.logger.info '==> FMServiceData.unset_service_count()'
    records = service(email_address, building_id)
    records.count
  rescue StandardError => e
    Rails.logger.warn "Couldn't retrieve service data count:#{e}"
  end

  # Get any service with an unset unit of measurement value
  # for a particular user and building
  def unit_of_measurement_unset(email_address, building_id)
    result_a = service(email_address, building_id)
    return_data = { 'hasService' => false }
    if result_a.count.positive?
      service = result_a[0].to_h
      code = service['code']
      # query for a uom description etc based on the service code
      description = service['name']
      query = "select fuom.title_text, fuom.example_text, fuom.unit_text from fm_units_of_measurement fuom where '" + code + "' in (select(unnest(service_usage)));"
      result_b = ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query(query) }
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
    Rails.logger.info '==> FMServiceData.add_uom_value()'
    query = "insert into fm_uom_values (user_id, service_code, uom_value, building_id)
     select '" + Base64.encode64(email_address) + "', '" + service_code + "', '" + value + "', '" + building_id + "'
		where not exists (select 1 from fm_uom_values where user_id = '" + Base64.encode64(email_address) + "'
				and service_code = '" + service_code + "'
				and building_id = '" + building_id + "');"
    ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query(query) }
  rescue StandardError => e
    Rails.logger.warn "Couldn't add unit of measurement data: #{e}"
  end

  def uom_values(email_address)
    Rails.logger.info '==> FMServiceData.uom_values()'
    query = "select building_id, service_code, uom_value from fm_uom_values where
	user_id = '" + Base64.encode64(email_address) + "' and service_code not in ('C.5'); "
    ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query(query) }
  rescue StandardError => e
    Rails.logger.warn "Couldn't get unit of measurement values: #{e}"
  end

  def save_lift_data(email_address, building_id, json_data)
    Rails.logger.info '==> FMServiceData.save_lift_data()'
    query = "insert into fm_lifts (user_id, building_id,lift_data)
		select '" + Base64.encode64(email_address) + "', '" + building_id + "', '" + json_data.to_json + "'
		 where not exists (select 1 from fm_lifts where
		 user_id = '" + Base64.encode64(email_address) + "' and building_id = '" + building_id + "');"
    ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query(query) }
    add_uom_value(email_address, building_id, 'C.5', 'Saved')
  rescue StandardError => e
    Rails.logger.warn "Couldn't save lift data : #{e}"
  end

  def get_lift_data(email_address)
    Rails.logger.info '==> FMServiceData.get_lift_data()'
    query = "select building_id, lift_data::jsonb->'lift_data'->>'lifts-qty' lift_qty, lift_data::jsonb->'lift_data'->>'total-floor-count' total_floor_count from fm_lifts
   where user_id =  '" + Base64.encode64(email_address) + "' limit 1;"
    ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query(query) }
  rescue StandardError => e
    Rails.logger.warn "Couldn't retrieve lift data : #{e}"
  end

  def services
    Rails.logger.info '==> FMServiceData.services()'
    query = "SELECT value::json FROM public.fm_static_data WHERE key = 'services';"
    result = ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query(query) }
    a = result.to_hash
    JSON.parse(a[0]['value'])
  rescue StandardError => e
    Rails.logger.warn "Couldn't retrieve services data : #{e}"
  end

  def work_package_description(code)
    result = ''
    workpackages = work_packages
    workpackages.each do |wp|
      result = wp['name'] unless wp['code'].to_s != code.to_s
    end
    result
  end

  def work_package_unit_text(code)
    result = ''
    work_packages.each do |wp|
      result = wp['unit_text'] unless wp['code'].to_s != code.to_s
    end
    result
  end

  def work_packages
    Rails.logger.info '==> FMServiceData.work_packages()'
    query = "SELECT value::json FROM public.fm_static_data WHERE key = 'work_packages';"
    result = ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query(query) }
    a = result.to_hash
    JSON.parse(a[0]['value'], create_additions: true)
  rescue StandardError => e
    Rails.logger.warn "Couldn't retrieve work_packages data : #{e}"
  end
end
