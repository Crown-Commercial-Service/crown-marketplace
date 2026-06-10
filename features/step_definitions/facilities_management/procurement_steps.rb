Then('I enter {string} into the contract name field') do |contract_name|
  @contract_name = contract_name
  procurement_page.contract_name_field.set(contract_name)
end

Then('I have a procurement with the name {string}') do |contract_name|
  @procurement = create(FRMAEOWRK_TO_FACTORY[@framework], user: @user, contract_name: contract_name)
end

FRMAEOWRK_TO_FACTORY = {
  'RM3830' => :facilities_management_rm3830_procurement,
  'RM6232' => :facilities_management_rm6232_procurement_what_happens_next,
  'RM6378' => :facilities_management_rm6378_procurement,
}.freeze

Then('the procurement {string} is on the dashboard') do |contract_name|
  expect(procurement_page).to have_link(contract_name)
end
