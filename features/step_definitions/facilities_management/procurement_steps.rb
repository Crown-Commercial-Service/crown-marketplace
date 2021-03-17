Then('I enter {string} into the contract name field') do |contract_name|
  @contract_name = contract_name
  procurement_page.contract_name_field.set(contract_name)
end

Then('I have a procurement with the name {string}') do |contract_name|
  create(:facilities_management_procurement, user: @user, contract_name: contract_name)
end

Given('I have an empty procurement in direct award named {string}') do |contract_name|
  create(:facilities_management_procurement_no_procurement_buildings, user: @user, contract_name: contract_name, service_codes: [], aasm_state: 'detailed_search')
end

Given('I have a procurement in direct award named {string} with the following services:') do |contract_name, service_codes_table|
  service_codes = service_codes_table.raw.flatten
  procurement = create(:facilities_management_procurement_no_procurement_buildings, user: @user, contract_name: contract_name, service_codes: service_codes, aasm_state: 'detailed_search')
  building = create(:facilities_management_building, building_name: 'Test building', user: @user)
  @procurement_building_id = procurement.procurement_buildings.create(building: building, service_codes: service_codes, active: true).id
end

Given('the GIA for {string} is {int}') do |building_name, gia|
  find_building(building_name).update(gia: gia)
end

Given('the external area for {string} is {int}') do |building_name, external_area|
  find_building(building_name).update(external_area: external_area)
end

def find_building(building_name)
  @user.buildings.find_by(building_name: building_name)
end

Given('I navigate to the service requirements page') do
  visit facilities_management_procurement_building_path(id: @procurement_building_id)
end

Then('I should see my procurement name') do
  expect(procurement_page.contract_name.text).to eq @contract_name
end

Then('{string} should have the status {string} in {string}') do |detail, status, section|
  expect(procurement_page.send(section).send(detail).status.text).to eq status.downcase
end

And('I select {string} for estimated annual cost known') do |option|
  if option == 'Yes'
    procurement_page.estimated_cost_known_yes.choose
  elsif option == 'No'
    procurement_page.estimated_cost_known_no.choose
  end
end

And('I enter {string} for estimated annual cost') do |estimated_annual_cost|
  procurement_page.estimated_cost_known.set(estimated_annual_cost)
end

Then('I select {string} for TUPE required') do |option|
  if option == 'Yes'
    procurement_page.tupe_yes.choose
  elsif option == 'No'
    procurement_page.tupe_no.choose
  end
end

Then('I enter {int} years and {int} months for the contract period') do |years, months|
  add_contract_period(years, months)
end

Then('I enter {int} year and {int} month for the contract period') do |years, months|
  add_contract_period(years, months)
end

Then('I enter {int} year and {int} months for the contract period') do |years, months|
  add_contract_period(years, months)
end

Then('I enter {int} years and {int} month for the contract period') do |years, months|
  add_contract_period(years, months)
end

def add_contract_period(years, months)
  procurement_page.initial_call_off_period_years.set(years)
  procurement_page.initial_call_off_period_months.set(months)
end

Then('I enter {string} as the inital call-off period start date') do |date|
  date_parts = case date.downcase
               when 'today'
                 Time.zone.today.strftime('%d/%m/%Y')
               when 'yesterday'
                 Time.zone.yesterday.strftime('%d/%m/%Y')
               when 'tomorrow'
                 Time.zone.tomorrow.strftime('%d/%m/%Y')
               else
                 date
               end.split('/')

  procurement_page.initial_call_off_period_day.set(date_parts[0])
  procurement_page.initial_call_off_period_month.set(date_parts[1])
  procurement_page.initial_call_off_period_year.set(date_parts[2])
end

Then('I select {string} for mobilisation period required') do |option|
  if option == 'Yes'
    procurement_page.mobilisation_period_yes.choose
  elsif option == 'No'
    procurement_page.mobilisation_period_no.choose
  end
end

Then('I select {string} for optional extension required') do |option|
  if option == 'Yes'
    procurement_page.extension_required_yes.choose
  elsif option == 'No'
    procurement_page.extension_required_no.choose
  end
end

Then('I should see the following seleceted services in the summary:') do |services_summary|
  expect(page.all('table > tbody > tr > td').map(&:text)).to match_array services_summary.raw.flatten
end

And('I find and select the building with the name {string}') do |building_name|
  continue = true

  while continue
    if page.text.include? building_name
      page.find('label', text: building_name).click
      continue = false
    elsif page.has_css?('.ccs-pagination') && first('.ccs-pagination')
      building.next_pagination.click
    else
      raise("Cannot find Building with name #{building_name}")
    end
  end
end

Then('I find and select the following buildings:') do |building_names|
  building_names.raw.flatten.each do |building_name|
    step "I find and select the building with the name '#{building_name}'"
  end
end

Then('I should see the following seleceted buildings in the summary:') do |buildings_summary|
  expect(page.all('table > tbody > tr > th').map(&:text)).to match_array buildings_summary.raw.flatten
end

Then('I select all services for the building') do
  page.check('box-all')
end

Then('I select all services for the building no js') do
  page.all('input[type="checkbox"]').each(&:check)
end

Then('I select the service {string} for the building') do |service|
  page.check(service)
end

Then('I select the service code {string} for the building') do |service|
  page.check("facilities_management_procurement_building_service_codes_#{service.downcase.gsub('.', '')}")
end

Then('I select the following services for the building:') do |services|
  services.raw.flatten.each do |service|
    page.check(service)
  end
end

Then('I select the following service codes for the building:') do |services|
  services.raw.flatten.each do |service|
    page.check("facilities_management_procurement_building_service_codes_#{service.downcase.gsub('.', '')}")
  end
end

Then('the building should have the status {string}') do |status|
  expect(procurement_page.building_status.text).to eq status
end

And('everything is completed') do
  expect(page.all('td > strong').all? { |status| status.text == 'completed' }).to be true
end

Then('Direct award is an available route to market') do
  expect(procurement_page.has_direct_award_route_to_market?).to be true
end

Then('I select {string} on results') do |option|
  case option.downcase
  when 'direct award'
    procurement_page.direct_award_route_to_market.choose
  when 'further competition'
    procurement_page.further_competition_route_to_market.choose
  end
end

Then('the procurement {string} is on the dashboard') do |contract_name|
  expect(procurement_page).to have_link(contract_name)
end

Then('the procurement {string} should have the state {string}') do |contract_name, status|
  expect(procurement_page.find('th', text: contract_name).find(:xpath, '../td[3]')).to have_content(status)
end

Then('the contract name is shown to be {string}') do |contract_name|
  expect(procurement_page.contract_name.text).to eq contract_name
end
