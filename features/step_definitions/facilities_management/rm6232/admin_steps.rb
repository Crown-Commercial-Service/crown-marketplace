Given('I have an inactive supplier called {string}') do |supplier_name|
  create(:facilities_management_rm6232_admin_suppliers_admin, supplier_name: supplier_name, active: nil, address_county: 'Essex')
end

Then('I should see all the suppliers') do
  expect(admin_rm6232_page.suppliers.length).to eq 50
end

Then('I enter {string} for the supplier search') do |supplier_name|
  admin_rm6232_page.supplier_search_input.fill_in with: "#{supplier_name}\n"
end

Then('I should see the following suppliers on the page:') do |supplier_names|
  expect(admin_rm6232_page.suppliers.length).to eq(supplier_names.raw.flatten.length)

  admin_rm6232_page.suppliers.map(&:supplier_name).zip(supplier_names.raw.flatten).each do |element, value|
    expect(element).to have_content(value)
  end
end

Then('I click on {string} for {string}') do |text, supplier_name|
  admin_rm6232_page.suppliers.find { |element| element.supplier_name.text == supplier_name }.send(text).click
end

Then('the supplier name shown is {string}') do |supplier_name|
  expect(admin_rm6232_page.supplier_name_sub_title).to have_content(supplier_name)
end

Then('they have services and regions for the following lots {string}') do |lots|
  expected_lots = lots.split(',').map(&:strip)
  actual_lots = admin_rm6232_page.lot_data_tables.map(&:title)

  expect(actual_lots.length).to eq expected_lots.length

  actual_lots.zip(expected_lots).each do |element, value|
    expect(element).to have_content(value)
  end
end

Then('I change the {string} for lot {string}') do |lot_data_type, lot_code|
  admin_rm6232_page.lot_data.send("lot_#{lot_code}").send(lot_data_type).change_link.click
end

Then('I deselect all checkboxes') do
  admin_rm6232_page.all('input[type="checkbox"][checked="checked"]').each(&:uncheck)
end

Then('I should see the following regions selected for lot {string}:') do |lot_code, regions|
  expected_regions = regions.raw.flatten
  actual_regions = admin_rm6232_page.lot_data.send("lot_#{lot_code}").regions.names.map(&:text)

  expect(actual_regions).to eq expected_regions
end

Then('I should see the following services selected for lot {string}:') do |lot_code, services|
  expected_services = services.raw.flatten
  actual_services = admin_rm6232_page.lot_data.send("lot_#{lot_code}").services.names.map(&:text)
  core_service_names = core_services(lot_code[0]).map(&:name)

  expect(core_service_names - actual_services).to be_empty
  expect(actual_services - core_service_names).to eq expected_services
end

Then("I can't select any core services") do
  core_service_labels = admin_rm6232_page.all('input[type="checkbox"][disabled]').map { |element| element.find(:xpath, '../label').text }
  core_service_names = core_services('1').map(&:label_name)

  expect(core_service_labels).to eq core_service_names
end

Then('I select {string} for the supplier status') do |option|
  case option
  when 'ACTIVE'
    admin_rm6232_page.active_true.choose
  when 'INACTIVE'
    admin_rm6232_page.active_false.choose
  end
end

Given('I go to a quick view with the following services, regions and annual contract value:') do |quick_view_data|
  service_codes = quick_view_data.transpose.raw[0].reject(&:blank?)
  region_codes = quick_view_data.transpose.raw[1].reject(&:blank?)
  annual_cost = quick_view_data.transpose.raw[2].first

  parameters = [
    service_codes.map { |code| "service_codes[]=#{code}" }.join('&'),
    region_codes.map { |code| "region_codes[]=#{code}" }.join('&'),
    "annual_contract_value=#{annual_cost}"
  ]

  visit "/facilities-management/RM6232/procurements/new?journey=facilities-management&#{parameters.join('&')}"
  expect(page.find('h1')).to have_content('Results')
end

Then('I {string} see the supplier {string} in the results') do |option, supplier|
  supplier_list = quick_view_page.results_container.suppliers.map(&:text)

  case option
  when 'should'
    expect(supplier_list).to include supplier
  when 'should not'
    expect(supplier_list).not_to include supplier
  end
end

Then('the supplier {string} {string} in the results') do |supplier, option|
  supplier_list = quick_view_page.results_container.suppliers.map(&:text)

  case option
  when 'is not'
    expect(supplier_list).not_to include supplier
  when 'is'
    expect(supplier_list).to include supplier
  end
end

def core_services(lot_number)
  FacilitiesManagement::RM6232::WorkPackage.selectable.map { |work_package| work_package.supplier_services.where(**LOT_NUMBER_TO_QUERY_PARAMS[lot_number]).select(&:core) }.flatten
end

LOT_NUMBER_TO_QUERY_PARAMS = {
  '1' => { total: true },
  '2' => { hard: true },
  '3' => { soft: true }
}.freeze
