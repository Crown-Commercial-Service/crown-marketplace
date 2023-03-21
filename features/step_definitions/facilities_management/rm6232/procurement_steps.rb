Then('the procurement name is shown to be {string}') do |contract_name|
  expect(page.find_by_id('procurement-subtitle')).to have_content(contract_name)
end

Then('the RM6232 procurement {string} should have the state {string}') do |contract_name, status|
  expect(procurement_page.find('th', text: contract_name).find(:xpath, '../td[2]')).to have_content(status)
end

When('the contract number is visible') do
  contract_number = @procurement.contract_number

  expect(page.find('#main-content > div:nth-child(2) > div > span')).to have_content("#{@procurement.contract_name} - #{contract_number}")
  expect(page.find('.ccs-panel__body')).to have_content(contract_number)
end

When('my sublot is {string}') do |sub_lot|
  expect(procurement_page.sub_lot).to have_content("Sub-lot #{sub_lot}")
end

When('I have {int} buildings in my results') do |number_of_buildings|
  expect(procurement_page.buildings.number).to have_content("Buildings (#{number_of_buildings})")
end

When('I have {int} services in my results') do |number_of_services|
  expect(procurement_page.services.number).to have_content("Services (#{number_of_services})")
end

Then('there are {int} suppliers shortlisted') do |number_of_suppliers|
  expect(procurement_page.number_of_suppliers).to have_content("#{number_of_suppliers} supplier(s) shortlisted")
end

Then('the buildings in my results are:') do |building_names|
  expect(procurement_page.buildings.names.length).to eq(building_names.raw.flatten.length)

  procurement_page.buildings.names.zip(building_names.raw.flatten).each do |element, value|
    expect(element).to have_content(value)
  end
end

Then('the services in my results are:') do |service_names|
  expect(procurement_page.services.names.length).to eq(service_names.raw.flatten.length)

  procurement_page.services.names.zip(service_names.raw.flatten).each do |element, value|
    expect(element).to have_content(value)
  end
end

Then('I should see the following procurements listed:') do |procurement_names|
  expect(procurement_page.saved_searches.search_names.length).to eq(procurement_names.raw.flatten.length)

  procurement_page.saved_searches.search_names.zip(procurement_names.raw.flatten).each do |element, value|
    expect(element).to have_content(value)
  end
end
