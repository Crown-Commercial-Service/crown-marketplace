Then('the procurement name is shown to be {string}') do |contract_name|
  expect(page.find_by_id('procurement-subtitle')).to have_content(contract_name)
end

When('the contract number is visible') do
  contract_number = @procurement.contract_number

  expect(page.find('#main-content > div:nth-child(2) > div > span')).to have_content("#{@procurement.contract_name} - #{contract_number}")
  expect(page.find('.ccs-panel__body')).to have_content(contract_number)
end

Then('I should see the following procurements listed:') do |procurement_names|
  expect(procurement_page.saved_searches.search_names.length).to eq(procurement_names.raw.flatten.length)

  procurement_page.saved_searches.search_names.zip(procurement_names.raw.flatten).each do |element, value|
    expect(element).to have_content(value)
  end
end
