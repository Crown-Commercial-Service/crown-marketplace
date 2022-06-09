And('everything is completed') do
  expect(page.all('td > strong').all? { |status| status.text == 'completed' }).to be true
end

And('I select {string} for estimated annual cost known') do |option|
  case option
  when 'Yes'
    entering_requirements_page.estimated_cost_known_yes.choose
  when 'No'
    entering_requirements_page.estimated_cost_known_no.choose
  end
end

And('I enter {string} for estimated annual cost') do |estimated_annual_cost|
  entering_requirements_page.estimated_cost_known.set(estimated_annual_cost)
end

Then('I select the service code {string} for the building') do |service|
  entering_requirements_page.check("facilities_management_rm3830_procurement_building_service_codes_#{service.downcase.gsub('.', '_')}")
end

Then('I select the following service codes for the building:') do |services|
  services.raw.flatten.each do |service|
    entering_requirements_page.check("facilities_management_rm3830_procurement_building_service_codes_#{service.downcase.gsub('.', '_')}")
  end
end

Then('the service requirements status for {string} is {string}') do |building_name, status|
  expect(building_status(building_name)).to have_content(status.downcase)
end

Given('I have a completed procurement for entering requirements named {string} with an initial call off period in the past') do |contract_name|
  create_completed_procurement(contract_name, initial_call_off_start_date: Time.zone.now - 6.months)
end

Given('I have a completed procurement for entering requirements named {string} with an mobilisation period in the past') do |contract_name|
  create_completed_procurement(contract_name, initial_call_off_start_date: Time.zone.now + 1.day, mobilisation_period_required: true, mobilisation_period: 4)
end

Given('I have a completed procurement for entering requirements named {string} with mobilisation less than four weeks') do |contract_name|
  create_completed_procurement(contract_name, mobilisation_period_required: true, mobilisation_period: 3, tupe: true)
end

Given('I have a completed procurement for entering requirements named {string} with buildings missing regions') do |contract_name|
  procurement = create(:facilities_management_rm3830_procurement_entering_requirements_complete, user: @user, contract_name: contract_name)
  buildings = (1..3).map { |index| create(:facilities_management_building, building_name: "Test building #{index}", user: @user, address_postcode: 'ST161AA', address_region: nil, address_region_code: nil) }

  buildings.each do |building|
    procurement.procurement_buildings.create(building: building, active: true, service_codes: procurement.service_codes)
  end

  procurement.procurement_building_services.each { |pbs| pbs.update(service_standard: 'A') }
end

Given('I have a completed procurement for entering requirements named {string}') do |contract_name|
  create_completed_procurement(contract_name)
end

Then('there are {int} buildings missing a region') do |number_of_buildings|
  expect(entering_requirements_page.all('tbody > tr').count).to eq number_of_buildings
end

Then('there is {int} building missing a region') do |number_of_buildings|
  step "there are #{number_of_buildings} buildings missing a region"
end

Then('I select region for {string}') do |building_name|
  entering_requirements_page.find('td', text: building_name).sibling('td', text: 'Select region').find('a').click
end

Then('I select {string} for the missing region') do |region|
  entering_requirements_page.region_drop_down.find(:option, region).select_option
end

def create_completed_procurement(contract_name, **options)
  procurement = create(:facilities_management_rm3830_procurement_entering_requirements_complete, user: @user, contract_name: contract_name, **options)
  building = create(:facilities_management_building, building_name: 'Test building', user: @user)

  procurement.procurement_buildings.create(building: building, active: true, service_codes: procurement.service_codes)
  procurement.procurement_building_services.each { |pbs| pbs.update(service_standard: 'A') }
end
