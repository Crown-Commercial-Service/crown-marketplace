Then('I enter {string} for the building name') do |building_name|
  building_page.building_name.set(building_name)
end

Then('I should see the postcode error message') do
  expect(building_page.postcode_error.visible?).to be true
  expect(building_page.postcode_error.text).to eq 'Enter a valid postcode, like AA1 1AA'
end

Then('I select {string} from the address drop down') do |address|
  building_page.address_drop_down.find(:option, address).select_option
end

Then('I select {string} from the region drop down') do |region|
  building_page.region_drop_down.find(:option, region).select_option
end

Then('I enter {string} for the building {string}') do |value, building_detail|
  building_page.building_input.send(building_detail.to_sym).set(value)
end

Then('I select {string} for the building type') do |building_type|
  building_page.find_field(building_type).choose
end

Then('I select {string} for the security type') do |security_type|
  building_page.choose(security_type)
end

Then('the address {string} is displayed') do |address|
  expect(building_page.address_text.text).to eq address
end

Then('the region {string} is displayed') do |region|
  expect(building_page.region_text.text).to eq region
end

Then("I can't change the region") do
  expect(building_page.change_region[:tabindex]).to eq '-1'
end

Then('I can change the region') do
  expect(building_page.change_region[:tabindex]).to eq '0'
end

Then('I am on the buildings summary page for {string}') do |building_name|
  expect(page.find('#main-content > div:nth-child(2) > div > span')).to have_content('Buildings')
  expect(page.find('h1')).to have_content(building_name)
end

Then("my building's status is {string}") do |status|
  expect(building_page.building_status).to have_content(/#{status}/i)
end

Then("my building's {string} is {string}") do |building_detail, text|
  expect(building_page.building_details_summary.send(building_detail.to_sym).value).to have_content(text)
end

Then('I change the {string}') do |building_detail|
  building_page.building_details_summary.send(building_detail.to_sym).link.click
end

Then('I change my building address') do
  building_page.change_address.click
end

And('the step is {int}') do |step_number|
  expect(building_page.step_number).to have_content("Step #{step_number} of 4")
end
