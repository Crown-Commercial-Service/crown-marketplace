Then('I check {string} for the sector') do |option|
  buyer_detail_page.sector.send(option.to_sym).choose
end

Then('I check {string} for being contacted') do |option|
  buyer_detail_page.contact_opt_in.send(option.to_sym).choose
end

Then('I should see the postcode error message for buyer details') do
  expect(buyer_detail_page.postcode_error_message).to have_text('Enter a valid postcode, for example SW1A 1AA')
end

Then('the following buyer details have been entered:') do |buyer_details_table|
  buyer_details_table.raw.to_h.each do |field, value|
    case field
    when 'Sector'
      expect(buyer_detail_page.sector.send(value.to_sym)).to be_checked
    when 'Contact opt in'
      expect(buyer_detail_page.contact_opt_in.send(value.to_sym)).to be_checked
    when 'Organisation address'
      expect(buyer_detail_page.buyer_details.send(field.to_sym)).to have_content value
    else
      expect(buyer_detail_page.buyer_details.send(field.to_sym).value).to eq value
    end
  end
end

Then('I change my contact detail address') do
  buyer_detail_page.change_address.click
end

Then('I select {string} from the address drop down') do |address|
  buyer_detail_page.address_drop_down.find(:option, address).select_option
end
