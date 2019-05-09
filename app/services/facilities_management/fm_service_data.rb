require 'json'
require 'base64'
require 'pg'
class FMServiceData
  def service(email_address, building_id)
    Rails.logger.info '=> FMServiceData.service()'
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
    Rails.logger.info '==> FMServiceData.unit_of_measurement_unset()'
    # first query for any unit value that is missing and get the details
    result_a = service(email_address, building_id)
    return_data = {}
    return_data['hasService'] = false

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
    query = "INSERT INTO fm_uom_values (user_id, service_code, uom_value,building_id)
             VALUES ('" + Base64.encode64(email_address) + "','" + service_code + "','" + value + "','" + building_id + "');"
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
    query = "INSERT INTO fm_lifts (user_id, building_id, lift_data) VALUES('" + Base64.encode64(email_address) + "', '" + building_id + "', '" + json_data.to_json + "');"
    ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query(query) }
    add_uom_value(email_address, building_id, 'C.5', 'Saved')
  rescue StandardError => e
    Rails.logger.warn "Couldn't save lift data : #{e}"
  end

  def get_lift_data(email_address)
    Rails.logger.info '==> FMServiceData.get_lift_data()'
    query = "select building_id, lift_data::jsonb->'lift_data'->>'lifts-qty' lift_qty, lift_data::jsonb->'lift_data'->>'total-floor-count' total_floor_count from fm_lifts
   where user_id =  '" + Base64.encode64(email_address) + "';"
    ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query(query) }
  rescue StandardError => e
    Rails.logger.warn "Couldn't retrieve lift data : #{e}"
  end

  # rubocop:disable Metrics/MethodLength
  def services
    JSON.parse('[
       {
           "code": "C",
           "name": "Maintenance services"
       },
       {
           "code": "D",
           "name": "Horticultural services"
       },
       {
           "code": "E",
           "name": "Statutory obligations"
       },
       {
           "code": "F",
           "name": "Catering services"
       },
       {
           "code": "G",
           "name": "Cleaning services"
       },
       {
           "code": "H",
           "name": "Workplace FM services"
       },
       {
           "code": "I",
           "name": "Reception services"
       },
       {
           "code": "J",
           "name": "Security services"
       },
       {
           "code": "K",
           "name": "Waste services"
       },
       {
           "code": "L",
           "name": "Miscellaneous FM services"
       },
       {
           "code": "M",
           "name": "Computer-aided facilities management (CAFM)"
       },
       {
           "code": "N",
           "name": "Helpdesk services"
       },
       {
           "code": "O",
           "name": "Management of billable works"
       }
   ]')
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
    JSON.parse('[
        {
            "code": "A.7",
            "name": "Accessibility services",
            "work_package_code": "A",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "A.12",
            "name": "Business continuity and disaster recovery (“BCDR”) plans",
            "work_package_code": "A",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "A.9",
            "name": "Customer satisfaction",
            "work_package_code": "A",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "A.5",
            "name": "Fire safety",
            "work_package_code": "A",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "A.2",
            "name": "Health and safety",
            "work_package_code": "A",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "A.1",
            "name": "Integration",
            "work_package_code": "A",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "A.3",
            "name": "Management services",
            "work_package_code": "A",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "A.11",
            "name": "Performance self-monitoring",
            "work_package_code": "A",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "A.6",
            "name": "Permit to work",
            "work_package_code": "A",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "A.16",
            "name": "Property information mapping service (EPIMS)",
            "work_package_code": "A",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "A.13",
            "name": "Quality management system",
            "work_package_code": "A",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "A.10",
            "name": "Reporting",
            "work_package_code": "A",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "A.8",
            "name": "Risk management",
            "work_package_code": "A",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "A.15",
            "name": "Selection and management of sub-contractors",
            "work_package_code": "A",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "A.4",
            "name": "Service delivery plans",
            "work_package_code": "A",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "A.18",
            "name": "Social value",
            "work_package_code": "A",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "A.14",
            "name": "Staff and training",
            "work_package_code": "A",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "A.17",
            "name": "Sustainability",
            "work_package_code": "A",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "B.1",
            "name": "Contract mobilisation",
            "work_package_code": "B",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "C.21",
            "name": "Airport and aerodrome maintenance services",
            "work_package_code": "C",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "C.15",
            "name": "Audio visual (AV) equipment maintenance",
            "work_package_code": "C",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "C.10",
            "name": "Automated barrier control system maintenance",
            "work_package_code": "C",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "C.11",
            "name": "Building management system (BMS) maintenance",
            "work_package_code": "C",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "C.14",
            "name": "Catering equipment maintenance",
            "work_package_code": "C",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "C.3",
            "name": "Environmental cleaning service",
            "work_package_code": "C",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "C.4",
            "name": "Fire detection and firefighting systems maintenance",
            "work_package_code": "C",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "C.13",
            "name": "High voltage (HV) and switchgear maintenance",
            "work_package_code": "C",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "C.7",
            "name": "Internal & external building fabric maintenance",
            "work_package_code": "C",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "C.5",
            "name": "Lifts, hoists & conveyance systems maintenance",
            "work_package_code": "C",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "C.20",
            "name": "Locksmith services",
            "work_package_code": "C",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "C.17",
            "name": "Mail room equipment maintenance",
            "work_package_code": "C",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "C.1",
            "name": "Mechanical and electrical engineering maintenance",
            "work_package_code": "C",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "C.18",
            "name": "Office machinery servicing and maintenance",
            "work_package_code": "C",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "C.9",
            "name": "Planned / group re-lamping service",
            "work_package_code": "C",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "C.8",
            "name": "Reactive maintenance services",
            "work_package_code": "C",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "C.6",
            "name": "Security, access and intruder systems maintenance",
            "work_package_code": "C",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "C.22",
            "name": "Specialist maintenance services",
            "work_package_code": "C",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "C.12",
            "name": "Standby power system maintenance",
            "work_package_code": "C",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "C.16",
            "name": "Television cabling maintenance",
            "work_package_code": "C",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "C.2",
            "name": "Ventilation and air conditioning system maintenance",
            "work_package_code": "C",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "C.19",
            "name": "Voice announcement system maintenance",
            "work_package_code": "C",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "D.6",
            "name": "Cut flowers and christmas trees",
            "work_package_code": "D",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "D.1",
            "name": "Grounds maintenance services",
            "work_package_code": "D",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "D.5",
            "name": "Internal planting",
            "work_package_code": "D",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "D.3",
            "name": "Professional snow & ice clearance",
            "work_package_code": "D",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "D.4",
            "name": "Reservoirs, ponds, river walls and water features maintenance",
            "work_package_code": "D",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "D.2",
            "name": "Tree surgery (arboriculture)",
            "work_package_code": "D",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "E.1",
            "name": "Asbestos management",
            "work_package_code": "E",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "E.9",
            "name": "Building information modelling and government soft landings",
            "work_package_code": "E",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "E.5",
            "name": "Compliance plans, specialist surveys and audits",
            "work_package_code": "E",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "E.6",
            "name": "Conditions survey",
            "work_package_code": "E",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "E.7",
            "name": "Electrical testing",
            "work_package_code": "E",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "E.8",
            "name": "Fire risk assessments",
            "work_package_code": "E",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "E.4",
            "name": "Portable appliance testing",
            "work_package_code": "E",
            "mandatory": true,
            "unit_text": "units (each year)"
        },
        {
            "code": "E.3",
            "name": "Statutory inspections",
            "work_package_code": "E",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "E.2",
            "name": "Water hygiene maintenance",
            "work_package_code": "E",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "F.1",
            "name": "Chilled potable water",
            "work_package_code": "F",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "F.2",
            "name": "Retail services / convenience store",
            "work_package_code": "F",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "F.3",
            "name": "Deli/coffee bar",
            "work_package_code": "F",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "F.4",
            "name": "Events and functions",
            "work_package_code": "F",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "F.5",
            "name": "Full service restaurant",
            "work_package_code": "F",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "F.6",
            "name": "Hospitality and meetings",
            "work_package_code": "F",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "F.7",
            "name": "Outside catering",
            "work_package_code": "F",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "F.8",
            "name": "Trolley service",
            "work_package_code": "F",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "F.9",
            "name": "Vending services (food & beverage)",
            "work_package_code": "F",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "F.10",
            "name": "Residential catering services",
            "work_package_code": "F",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "G.8",
            "name": "Cleaning of communications and equipment rooms",
            "work_package_code": "G",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "G.13",
            "name": "Cleaning of curtains and window blinds",
            "work_package_code": "G",
            "mandatory": false,
            "unit_text": "occupants (each year)"
        },
        {
            "code": "G.5",
            "name": "Cleaning of external areas",
            "work_package_code": "G",
            "mandatory": true,
            "unit_text": "sqm (square metres)"
        },
        {
            "code": "G.2",
            "name": "Cleaning of integral barrier mats",
            "work_package_code": "G",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "G.4",
            "name": "Deep (periodic) cleaning",
            "work_package_code": "G",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "G.10",
            "name": "Housekeeping",
            "work_package_code": "G",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "G.11",
            "name": "It equipment cleaning",
            "work_package_code": "G",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "G.16",
            "name": "Linen and laundry services",
            "work_package_code": "G",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "G.14",
            "name": "Medical and clinical cleaning",
            "work_package_code": "G",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "G.3",
            "name": "Mobile cleaning services",
            "work_package_code": "G",
            "mandatory": true,
            "unit_text": "occupants (each year)"
        },
        {
            "code": "G.15",
            "name": "Pest control services",
            "work_package_code": "G",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "G.9",
            "name": "Reactive cleaning (outside cleaning operational hours)",
            "work_package_code": "G",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "G.1",
            "name": "Routine cleaning",
            "work_package_code": "G",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "G.12",
            "name": "Specialist cleaning",
            "work_package_code": "G",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "G.7",
            "name": "Window cleaning (external)",
            "work_package_code": "G",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "G.6",
            "name": "Window cleaning (internal)",
            "work_package_code": "G",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "H.16",
            "name": "Administrative support services",
            "work_package_code": "H",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "H.9",
            "name": "Archiving (on-site)",
            "work_package_code": "H",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "H.12",
            "name": "Cable management",
            "work_package_code": "H",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "H.7",
            "name": "Clocks",
            "work_package_code": "H",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "H.3",
            "name": "Courier booking and external distribution",
            "work_package_code": "H",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "H.10",
            "name": "Furniture management",
            "work_package_code": "H",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "H.4",
            "name": "Handyman services",
            "work_package_code": "H",
            "mandatory": true,
            "unit_text": "hours per week"
        },
        {
            "code": "H.2",
            "name": "Internal messenger service",
            "work_package_code": "H",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "H.1",
            "name": "Mail services",
            "work_package_code": "H",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "H.5",
            "name": "Move and space management - internal moves",
            "work_package_code": "H",
            "mandatory": true,
            "unit_text": "hours per week"
        },
        {
            "code": "H.15",
            "name": "Portable washroom solutions",
            "work_package_code": "H",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "H.6",
            "name": "Porterage",
            "work_package_code": "H",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "H.13",
            "name": "Reprographics service",
            "work_package_code": "H",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "H.8",
            "name": "Signage",
            "work_package_code": "H",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "H.11",
            "name": "Space management",
            "work_package_code": "H",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "H.14",
            "name": "Stores management",
            "work_package_code": "H",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "I.3",
            "name": "Car park management and booking",
            "work_package_code": "I",
            "mandatory": true,
            "unit_text": "hours per week"
        },
        {
            "code": "I.1",
            "name": "Reception service",
            "work_package_code": "I",
            "mandatory": true,
            "unit_text": "hours per week"
        },
        {
            "code": "I.2",
            "name": "Taxi booking service",
            "work_package_code": "I",
            "mandatory": true,
            "unit_text": "hours per week"
        },
        {
            "code": "I.4",
            "name": "Voice announcement system operation",
            "work_package_code": "I",
            "mandatory": true,
            "unit_text": "hours per week"
        },
        {
            "code": "J.8",
            "name": "Additional security services",
            "work_package_code": "J",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "J.2",
            "name": "Cctv / alarm monitoring",
            "work_package_code": "J",
            "mandatory": true,
            "unit_text": "hours per week"
        },
        {
            "code": "J.3",
            "name": "Control of access and security passes",
            "work_package_code": "J",
            "mandatory": true,
            "unit_text": "hours per week"
        },
        {
            "code": "J.4",
            "name": "Emergency response",
            "work_package_code": "J",
            "mandatory": true,
            "unit_text": "hours per week"
        },
        {
            "code": "J.9",
            "name": "Enhanced security requirements",
            "work_package_code": "J",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "J.10",
            "name": "Key holding",
            "work_package_code": "J",
            "mandatory": false,
            "unit_text": "hours per week"
        },
        {
            "code": "J.11",
            "name": "Lock up / open up of buyer premises",
            "work_package_code": "J",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "J.6",
            "name": "Management of visitors and passes",
            "work_package_code": "J",
            "mandatory": true,
            "unit_text": "hours per week"
        },
        {
            "code": "J.1",
            "name": "Manned guarding service",
            "work_package_code": "J",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "J.5",
            "name": "Patrols (fixed or static guarding)",
            "work_package_code": "J",
            "mandatory": true,
            "unit_text": "hours per week"
        },
        {
            "code": "J.12",
            "name": "Patrols (mobile via a specific visiting vehicle)",
            "work_package_code": "J",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "J.7",
            "name": "Reactive guarding",
            "work_package_code": "J",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "K.1",
            "name": "Classified waste",
            "work_package_code": "K",
            "mandatory": true,
            "unit_text": "units (each year)"
        },
        {
            "code": "K.5",
            "name": "Clinical waste",
            "work_package_code": "K",
            "mandatory": false,
            "unit_text": "tonnes (each year)"
        },
        {
            "code": "K.7",
            "name": "Feminine hygiene waste",
            "work_package_code": "K",
            "mandatory": true,
            "unit_text": "units (each year)"
        },
        {
            "code": "K.2",
            "name": "General waste",
            "work_package_code": "K",
            "mandatory": true,
            "unit_text": "tonnes (each year)"
        },
        {
            "code": "K.4",
            "name": "Hazardous waste",
            "work_package_code": "K",
            "mandatory": false,
            "unit_text": "tonnes (each year)"
        },
        {
            "code": "K.6",
            "name": "Medical waste",
            "work_package_code": "K",
            "mandatory": false,
            "unit_text": "tonnes (each year)"
        },
        {
            "code": "K.3",
            "name": "Recycled waste",
            "work_package_code": "K",
            "mandatory": true,
            "unit_text": "tonnes (each year)"
        },
        {
            "code": "L.1",
            "name": "Childcare facility",
            "work_package_code": "L",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "L.2",
            "name": "Sports and leisure",
            "work_package_code": "L",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "L.3",
            "name": "Driver and vehicle service",
            "work_package_code": "L",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "L.4",
            "name": "First aid and medical service",
            "work_package_code": "L",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "L.5",
            "name": "Flag flying service",
            "work_package_code": "L",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "L.6",
            "name": "Journal, magazine and newspaper supply",
            "work_package_code": "L",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "L.7",
            "name": "Hairdressing services",
            "work_package_code": "L",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "L.8",
            "name": "Footwear cobbling services",
            "work_package_code": "L",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "L.9",
            "name": "Provision of chaplaincy support services",
            "work_package_code": "L",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "L.10",
            "name": "Housing and residential accommodation management",
            "work_package_code": "L",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "L.11",
            "name": "Training establishment management and booking service",
            "work_package_code": "L",
            "mandatory": false,
            "unit_text": ""
        },
        {
            "code": "M.1",
            "name": "CAFM system",
            "work_package_code": "M",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "N.1",
            "name": "Helpdesk services",
            "work_package_code": "N",
            "mandatory": true,
            "unit_text": ""
        },
        {
            "code": "O.1",
            "name": "Management of billable works",
            "work_package_code": "O",
            "mandatory": true,
            "unit_text": ""
        }]', create_additions: true)
  end
  # rubocop:enable Metrics/MethodLength
end
