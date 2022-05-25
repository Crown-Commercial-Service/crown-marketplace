Given('I have an RM6232 procurement with the name {string}') do |contract_name|
  create(:facilities_management_rm6232_procurement_what_happens_next, user: @user, contract_name: contract_name)
end

Given('I have an empty procurement for {string} named {string}') do |state, contract_name|
  @procurement = create(:facilities_management_rm6232_procurement_what_happens_next, user: @user, contract_name: contract_name, aasm_state: state)
end

Then('the procurement name is shown to be {string}') do |contract_name|
  expect(page.find('#procurement-subtitle')).to have_content(contract_name)
end

Then('the RM6232 procurement {string} should have the state {string}') do |contract_name, status|
  expect(procurement_page.find('th', text: contract_name).find(:xpath, '../td[2]')).to have_content(status)
end

When('the contract number is visible') do
  contract_number = @procurement.contract_number

  expect(page.find('#main-content > div:nth-child(2) > div > span')).to have_content("#{@procurement.contract_name} - #{contract_number}")
  expect(page.find('.ccs-panel__body')).to have_content(contract_number)
end
