Then('I check {string} for the sector') do |option|
  buyer_detail_page.sector.send(option.to_sym).choose
end

Then('I check {string} for being contacted') do |option|
  buyer_detail_page.contact_opt_in.send(option.to_sym).choose
end

Then('I should see the postcode error message for buyer details') do
  expect(buyer_detail_page.postcode_error_message).to have_text('Enter a valid postcode, for example SW1A 1AA')
end

Then('I should not see the postcode error message for buyer details') do
  expect(buyer_detail_page.all('#organisation_address_postcode-error').length).to be_zero
end

Then('I should see the other address field error messages for buyer details') do
  expect(buyer_detail_page.address_line_1_error_message).to have_text('Enter your building or street name')
  expect(buyer_detail_page.town_or_city_error_message).to have_text('Enter your town or city')
end

Then('I should not see the other address errors') do
  expect(buyer_detail_page.all('#organisation_address_line_1-error').length).to be_zero
  expect(buyer_detail_page.all('#organisation_address_town-error').length).to be_zero
end

Then('the following buyer details have been entered for {string}:') do |section, buyer_details_table|
  row_sections = buyer_detail_page.buyer_details.send(section.to_sym).rows

  row_sections.zip(buyer_details_table.raw).each do |section, (field, value)|
    expect(section.key).to have_content(field)
    expect(section.value).to have_content(value)
  end
end

Then('I change my contact detail address') do
  buyer_detail_page.change_address.click
end

Then('I select {string} from the address drop down') do |address|
  buyer_detail_page.address_drop_down.find(:option, address).select_option
end
