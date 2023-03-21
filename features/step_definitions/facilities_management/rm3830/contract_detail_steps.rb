Given('I have a procurement in DA draft at the {string} stage named {string}') do |da_journey_state, contract_name|
  create(:facilities_management_rm3830_procurement_direct_award, user: @user, contract_name: contract_name, aasm_state: 'da_draft', da_journey_state: da_journey_state)
end

Given('I have a procurement with completed contract details named {string}') do |contract_name|
  create(:facilities_management_rm3830_procurement_with_contact_details, user: @user, contract_name: contract_name, aasm_state: 'da_draft', da_journey_state: 'contract_details')
end

When('I answer the {string} contract detail question') do |contract_detail|
  contract_detail_page.contract_details.send(contract_detail.to_sym).question.click
end

Then('my answer to the {string} contract detail question is {string}') do |contract_detail, answer|
  expect(contract_detail_page.contract_details.send(contract_detail.to_sym).answer).to have_content(answer)
end

Given('I pick {string} for the governing law') do |law|
  contract_detail_page.choose(law)
end

Given('I pick {string} for the payment method') do |payment_method|
  contract_detail_page.choose(payment_method)
end

Given('I select {string} for the security policy document question') do |option|
  contract_detail_page.choose(option)
end

Given('I select {string} for the LGPS question') do |option|
  contract_detail_page.choose(option)
end

Given('I select {string} for the contact details') do |option|
  contract_detail_page.choose(option)
end

Given('I select the buyer details for the contact details') do
  contract_detail_page.buyer_details.choose
end

Given('I enter {string} for the security policy document {string}') do |value, attribute|
  case attribute
  when 'name'
    contract_detail_page.security_policy_document.name.set(value)
  when 'number'
    contract_detail_page.security_policy_document.number.set(value)
  when 'date'
    date = value.split('/')

    contract_detail_page.security_policy_document.date_day.set(date[0])
    contract_detail_page.security_policy_document.date_month.set(date[1])
    contract_detail_page.security_policy_document.date_year.set(date[2])
  end
end

Given('I upload security policy document that is {string}') do |option|
  filepath = case option
             when 'valid'
               Rails.public_path.join('facilities-management', 'rm3830', 'Attachment 1 - About the Direct Award v3.0.pdf')
             when 'invalid'
               Rails.root.join('features', 'facilities_management', 'rm3830', 'procurements', 'contract_details', 'validations', 'security_policy_document_validations.feature')
             end

  contract_detail_page.security_policy_document.file.attach_file(filepath)
end

Then('I enter the name {string} and {string} percent for pension number {int}') do |pension_name, pension_percentage, pension_number|
  raise if contract_detail_page.pension_fund_rows.size < pension_number

  pension_row = contract_detail_page.pension_fund_rows[pension_number - 1]
  pension_row.find('.pension-name').set(pension_name)
  pension_row.find('.pension-percentage').set(pension_percentage)
end

Then('I add {int} pension funds') do |number_of_pensions|
  number_of_pensions.times { contract_detail_page.add_pension_fund.click }
end

Then('I add {int} pension fund') do |number_of_pensions|
  number_of_pensions.times { contract_detail_page.add_pension_fund.click }
end

Then('I remove pension fund number {int}') do |pension_number|
  raise if contract_detail_page.pension_fund_rows.size < pension_number

  pension_row = contract_detail_page.pension_fund_rows[pension_number - 1]
  pension_row.find('.remove-pension-record ').click
end

Then('pension {int} should have the following error messages:') do |pension_number, error_messages|
  raise if contract_detail_page.pension_fund_rows.size < pension_number

  pension_row = contract_detail_page.pension_fund_rows[pension_number - 1]
  expect(pension_row.all('.govuk-error-message').map(&:text)).to match(error_messages.raw.flatten)
end

Then('the following pensions are listed:') do |pension_schemes|
  expect(contract_detail_page.contract_details.send(:'Local Government Pension Scheme').pension_schemes.map(&:text)).to match(pension_schemes.raw.flatten)
end

Then('there are {int} pension fund rows') do |pension_rows|
  expect(contract_detail_page.pension_fund_rows.size).to eq pension_rows
end

Then('the add pension fund button has text {string}') do |button_text|
  expect(contract_detail_page.add_pension_fund).to have_content(button_text)
end

Then('I enter {string} for the invoicing contact detail {string}') do |value, attribute|
  contract_detail_page.invoicing_contact_detail.send(attribute.to_sym).set(value)
end

Then('I enter {string} for the authorised representative detail {string}') do |value, attribute|
  contract_detail_page.authorised_representative_detail.send(attribute.to_sym).set(value)
end

Then('I enter {string} for the notices contact detail {string}') do |value, attribute|
  contract_detail_page.notices_contact_detail.send(attribute.to_sym).set(value)
end

Then('I open the details for the {string}') do |contact_detail|
  contract_detail_page.contract_details.send(contact_detail.to_sym).name.click
end

Then('my {string} contact detail name matchs the buyer details') do |contact_detail|
  answer = "#{@user.buyer_detail.full_name}, #{@user.buyer_detail.full_name}"

  step "my '#{contact_detail}' contact detail name is '#{answer}'"
end

Then('my {string} contact details match the buyer details') do |contact_detail|
  if contact_detail == 'Authorised representative details'
    step "my '#{contact_detail}' contact details are as follows:", table(%(
      | #{@user.email}                                  |
      | #{@user.buyer_detail.telephone_number}          |
      | #{@user.buyer_detail.full_organisation_address} |
    ))
  else
    step "my '#{contact_detail}' contact details are as follows:", table(%(
      | #{@user.email}                                  |
      | #{@user.buyer_detail.full_organisation_address} |
    ))
  end
end

Then('I should see {string} for the contact detail name') do |name|
  expect(contract_detail_page.contact_detail.name).to have_content(name)
end

Then('I should see {string} for the contact detail address') do |address|
  expect(contract_detail_page.contact_detail.address).to have_content(address)
end

Then('my {string} contact detail name is {string}') do |contact_detail, name|
  expect(contract_detail_page.contract_details.send(contact_detail.to_sym).name).to have_content name
end

Then('my {string} contact details are as follows:') do |contact_detail, contact_details|
  full_contact_details = contact_details.raw.flatten

  answer = if full_contact_details.size == 3
             "#{full_contact_details[0]} Telephone: #{full_contact_details[1]} Address: #{full_contact_details[2]}"
           else
             "#{full_contact_details[0]} Address: #{full_contact_details[1]}"
           end

  expect(contract_detail_page.contract_details.send(contact_detail.to_sym).contact_detail).to have_content answer
end

Then('I change my contact detail postcode') do
  contract_detail_page.change_postcode.click
end
