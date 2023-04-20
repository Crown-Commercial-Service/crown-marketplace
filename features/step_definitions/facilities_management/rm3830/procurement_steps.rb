Given('I have an empty procurement with buildings named {string} with the following servcies assigned:') do |contract_name, service_codes_table|
  service_codes = service_codes_table.raw.flatten

  procurement = create(:facilities_management_rm3830_procurement_entering_requirements, user: @user, contract_name: contract_name, service_codes: service_codes)

  @user.buildings.each do |building|
    procurement.procurement_buildings.create(building: building, active: true, service_codes: service_codes)
  end
end

Given('I have a procurement in detailed search named {string} with the following services:') do |contract_name, service_codes_table|
  service_codes = service_codes_table.raw.flatten
  procurement = create(:facilities_management_rm3830_procurement_no_procurement_buildings, user: @user, contract_name: contract_name, service_codes: service_codes, aasm_state: 'detailed_search')
  building = create(:facilities_management_building, building_name: 'Test building', user: @user)
  @procurement_building_id = procurement.procurement_buildings.create(building: building, service_codes: service_codes, active: true).id
end

Given('I have a procurement in detailed search named {string} with the following services and multiple buildings:') do |contract_name, service_codes_table|
  create(:facilities_management_building, building_name: 'Test building', user: @user, building_type: 'Warehouses')
  create(:facilities_management_building_london, building_name: 'Test London building', user: @user, building_type: 'Primary School')

  service_codes = service_codes_table.raw.flatten
  procurement = create(:facilities_management_rm3830_procurement_no_procurement_buildings, user: @user, contract_name: contract_name, service_codes: service_codes, aasm_state: 'detailed_search')

  @user.buildings.each do |building|
    procurement.procurement_buildings.create(building: building, active: true, service_codes: service_codes)
  end
end

Given('I have direct award procurements') do
  create_contracts(@user, FacilitiesManagement::RM3830::SupplierDetail.find('ca57bf4c-e8a5-468a-95f4-39fcf730c770'))
end

Given('the GIA for {string} is {int}') do |building_name, gia|
  find_building(building_name).update(gia:)
end

Given('the external area for {string} is {int}') do |building_name, external_area|
  find_building(building_name).update(external_area:)
end

Given('I navigate to the service requirements page') do
  visit facilities_management_rm3830_procurement_building_path(id: @procurement_building_id)
end

Then('I should see my procurement name') do
  expect(procurement_page.contract_name.text).to eq @contract_name
end

Then('I should see my name is {string}') do |contract_name|
  expect(procurement_page.contract_name.text).to eq contract_name
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

Then('the procurement {string} should have the state {string}') do |contract_name, status|
  expect(procurement_page.find('th', text: contract_name).find(:xpath, '../td[3]')).to have_content(status)
end

Then('the contract name is shown to be {string}') do |contract_name|
  expect(procurement_page.contract_name.text).to eq contract_name
end

Then('I answer the question for {string} on contract details') do |contract_detail|
  procurement_page.send(contract_detail).answer_question.click
end

Then('the assessed value is {string}') do |price|
  expect(procurement_page.estimated_contract_cost).to have_content(price)
end

Then('the selected supplier is {string}') do |supplier|
  expect(procurement_page.selected_supplier).to have_content(supplier)
end

Then('I choose to delete the procurement named {string}') do |contract_name|
  procurement_page.find('th', text: contract_name).find(:xpath, '../td[4]/a').click
end

Then('my procurement {string} has successfully been deleted') do |contract_name|
  expect(procurement_page.find('.govuk-notification-banner__heading')).to have_content('Your item was deleted')
  expect(procurement_page.find('.govuk-notification-banner__content > p.govuk-body')).to have_content("'#{contract_name}' was deleted")
end
