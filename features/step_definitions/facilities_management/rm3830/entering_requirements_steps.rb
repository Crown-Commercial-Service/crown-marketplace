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

Then('the summary should say {int} servcies selected') do |number_of_selected_servcies|
  expect(entering_requirements_page.number_of_selected_servcies).to have_content("#{number_of_selected_servcies} services")
end

Then('the summary should say {int} servcie selected') do |number_of_selected_servcies|
  expect(entering_requirements_page.number_of_selected_servcies).to have_content("#{number_of_selected_servcies} service")
end

Then('I should see the following seleceted services in the summary:') do |services_summary|
  expect(entering_requirements_page.all('table > tbody > tr > td').map(&:text)).to match services_summary.raw.flatten
end

And('I find and select the building with the name {string}') do |building_name|
  continue = true

  while continue
    if entering_requirements_page.text.include? building_name
      entering_requirements_page.find('label', text: building_name).click
      continue = false
    elsif entering_requirements_page.has_css?('.ccs-pagination') && first('.ccs-pagination')
      entering_requirements_page.next_pagination.click
    else
      raise("Cannot find Building with name #{building_name}")
    end
  end
end

Then('I click on the details for {string}') do |building_name|
  entering_requirements_page.find("a[aria-label='Details for \"#{building_name}\"']").click
end

Then('I find and select the following buildings:') do |building_names|
  building_names.raw.flatten.each do |building_name|
    step "I find and select the building with the name '#{building_name}'"
  end
end

Then('there are no buildings to select') do
  expect(entering_requirements_page.no_buildings_text).to have_content("You have no saved buildings. Click on 'Add a building' to start setting up your building(s)")
end

Then('the summary should say {int} buildings selected') do |number_of_selected_buildings|
  expect(entering_requirements_page.number_of_selected_buildings).to have_content("#{number_of_selected_buildings} buildings")
end

Then('the summary should say {int} building selected') do |number_of_selected_buildings|
  expect(entering_requirements_page.number_of_selected_buildings).to have_content("#{number_of_selected_buildings} building")
end

Given('I have incomplete buildings') do
  create(:facilities_management_building, building_name: 'Test incomplete building', user: @user, address_region: nil, address_region_code: nil)
  create(:facilities_management_building_london, building_name: 'Test incomplete London building', user: @user, address_region: nil, address_region_code: nil)
end

Then('the following buildings can be selected:') do |building_names|
  building_names.raw.flatten.each do |building_name|
    expect(entering_requirements_page).to have_selector('label', text: building_name)
  end
end

Then('the following buildings cannot be selected:') do |building_names|
  building_names.raw.flatten.each do |building_name|
    expect(entering_requirements_page).not_to have_selector('label', text: building_name)
  end
end

Then('the following buildings are selected:') do |building_names|
  expect(entering_requirements_page.checked_buildings.map { |element| element.find(:xpath, './../label/span[1]').text }).to match(building_names.raw.flatten)
end

Then('no buildings are selected') do
  expect(entering_requirements_page.checked_buildings).to be_empty
end

Then('I deselect building {string}') do |building_name|
  entering_requirements_page.find('label', text: building_name).click
end

Then('I should see the following seleceted buildings in the summary:') do |buildings_summary|
  expect(page.all('table > tbody > tr > th').map(&:text)).to match buildings_summary.raw.flatten
end

Given('I have {int} buildings') do |number_of_buildings|
  number_of_buildings.times do |building_number|
    create(:facilities_management_building, building_name: "Test building #{format('%03d', building_number + 1)}", user: @user)
  end
end

Then('I select all services for the building') do
  if @javascript
    entering_requirements_page.select_all_services_checkbox.check
  else
    entering_requirements_page.all_checkboxes.each(&:check)
  end
end

Then('I select the service {string} for the building') do |service|
  entering_requirements_page.check(service)
end

Then('I deselect the service {string} for the building') do |service|
  entering_requirements_page.uncheck(service)
end

Then('I select the service code {string} for the building') do |service|
  entering_requirements_page.check("facilities_management_rm3830_procurement_building_service_codes_#{service.downcase.gsub('.', '_')}")
end

Then('I select the following services for the building:') do |services|
  services.raw.flatten.each do |service|
    entering_requirements_page.check(service)
  end
end

Then('I select the following service codes for the building:') do |services|
  services.raw.flatten.each do |service|
    entering_requirements_page.check("facilities_management_rm3830_procurement_building_service_codes_#{service.downcase.gsub('.', '_')}")
  end
end

Then('the assigning services to buildings status should be {string}') do |status|
  expect(entering_requirements_page.assigning_services_to_buildings_status.text).to eq status.downcase
end

Then('the building named {string} should have no services selected') do |building_name|
  expect(building_status(building_name)).to have_content('No service selected')
end

Then('the building named {string} should say {int} services selected') do |building_name, number_of_selected_services|
  expect(building_status(building_name).find('summary')).to have_content("#{number_of_selected_services} services selected")
end

Then('the building named {string} should say {int} service selected') do |building_name, number_of_selected_services|
  expect(building_status(building_name).find('summary')).to have_content("#{number_of_selected_services} service selected")
end

Then('I open the selected services for {string}') do |building_name|
  building_status(building_name).find('summary').click
end

Then('the following services have been selected for {string}:') do |building_name, selected_services_table|
  expect(building_status(building_name).all('ul > li').map(&:text)).to match selected_services_table.raw.flatten
end

Then('select all should be {string}') do |status|
  case status
  when 'checked'
    expect(entering_requirements_page.select_all_services_checkbox).to be_checked
  when 'unchecked'
    expect(entering_requirements_page.select_all_services_checkbox).not_to be_checked
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

def building_status(building_name)
  entering_requirements_page.find(:xpath, "//td[* = '#{building_name}']/following-sibling::td")
end

def create_completed_procurement(contract_name, **options)
  procurement = create(:facilities_management_rm3830_procurement_entering_requirements_complete, user: @user, contract_name: contract_name, **options)
  building = create(:facilities_management_building, building_name: 'Test building', user: @user)

  procurement.procurement_buildings.create(building: building, active: true, service_codes: procurement.service_codes)
  procurement.procurement_building_services.each { |pbs| pbs.update(service_standard: 'A') }
end
