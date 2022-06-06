Then('I enter {string} into the contract name field') do |contract_name|
  @contract_name = contract_name
  procurement_page.contract_name_field.set(contract_name)
end

Then('I have a procurement with the name {string}') do |contract_name|
  create(FRMAEOWRK_AND_STATE_TO_FACTORY[@framework][:initial], user: @user, contract_name: contract_name)
end

Given('I have an empty procurement for entering requirements named {string}') do |contract_name|
  create(FRMAEOWRK_AND_STATE_TO_FACTORY[@framework][:empty_entering_requirements], user: @user, contract_name: contract_name)
end

Given('I have an empty procurement for entering requirements named {string} with the following servcies:') do |contract_name, service_codes_table|
  create(FRMAEOWRK_AND_STATE_TO_FACTORY[@framework][:empty_entering_requirements], user: @user, contract_name: contract_name, service_codes: service_codes_table.raw.flatten)
end

FRMAEOWRK_AND_STATE_TO_FACTORY = {
  'RM3830' => {
    initial: :facilities_management_rm3830_procurement,
    empty_entering_requirements: :facilities_management_rm3830_procurement_entering_requirements
  },
  'RM6232' => {
    initial: :facilities_management_rm6232_procurement_what_happens_next,
    empty_entering_requirements: :facilities_management_rm6232_procurement_entering_requirements_empty,
    entering_requirements: :facilities_management_rm6232_procurement_entering_requirements
  }
}.freeze

Then('the procurement {string} is on the dashboard') do |contract_name|
  expect(procurement_page).to have_link(contract_name)
end
