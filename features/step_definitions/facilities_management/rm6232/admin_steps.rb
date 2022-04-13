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

Then('they have services and regions for the following lots:') do |lots|
  admin_rm6232_page.lot_data_tables.map(&:title).zip(lots.raw.flatten).each do |element, value|
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
  core_service_names = core_services.map(&:name)

  expect(core_service_names - actual_services).to be_empty
  expect(actual_services - core_service_names).to eq expected_services
end

Then("I can't select any core services") do
  core_service_labels = admin_rm6232_page.all('input[type="checkbox"][disabled]').map { |element| element.find(:xpath, '../label').text }
  core_service_names = core_services.map(&:label_name)

  expect(core_service_labels).to eq core_service_names
end

def core_services
  FacilitiesManagement::RM6232::WorkPackage.selectable.map { |work_package| work_package.services.select(&:core) }.flatten
end
