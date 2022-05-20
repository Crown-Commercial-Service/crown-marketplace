Given('I have an RM6232 procurement with the name {string}') do |contract_name|
  create(:facilities_management_rm6232_procurement_no_procurement_buildings, :skip_before_create, user: @user, contract_name: contract_name)
end

Then('the procurement name is shown to be {string}') do |contract_name|
  expect(page.find('#main-content > div:nth-child(2) > div > span')).to have_content(contract_name)
end
