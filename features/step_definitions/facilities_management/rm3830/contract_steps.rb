Given('I have a contract that has been {string} called {string}') do |state, contract_name|
  procurement = create(:facilities_management_rm3830_procurement_completed_procurement_no_suppliers, user: @user, contract_name: contract_name)
  procurement.procurement_suppliers.create(supplier: find_supplier, aasm_state: state, direct_award_value: 5000, offer_sent_date: Time.zone.today - 4.days, **PROCUREMENT_SUPPLIER_ATTRIBUTES[state.to_sym])
  procurement.procurement_suppliers.create(supplier: find_other_supplier('4dbe4d9c-37bb-4bd6-a8a7-35e36cf99f64'), aasm_state: 'unsent', direct_award_value: 50000)
end

Given('I have a contract that has been {string} called {string} and there are no more suppliers') do |state, contract_name|
  procurement = create(:facilities_management_rm3830_procurement_completed_procurement_no_suppliers, user: @user, contract_name: contract_name)
  procurement.procurement_suppliers.create(supplier: find_supplier, aasm_state: state, direct_award_value: 5000, offer_sent_date: Time.zone.today - 4.days, **PROCUREMENT_SUPPLIER_ATTRIBUTES[state.to_sym])
end

When('I navigate to the contract {string} in {string}') do |contract_name, table|
  procurement_page.send(table.to_sym).click_on(contract_name)
  step 'I am on the "Contract summary" page'
end

Then('the supplier name is {string}') do |supplier_name|
  expect(contract_page.supplier_name).to have_content(supplier_name)
  expect(contract_page.supplier_contact_details.supplier_name).to have_content(supplier_name)
end

Then('the supplier details are:') do |supplier_details|
  contact_details = contract_page.supplier_contact_details.details

  supplier_details.raw.flatten.each do |supplier_detail|
    expect(contact_details).to have_content supplier_detail
  end
end

Then('there is a warning with the text {string}') do |warning_text|
  expect(contract_page.warning_text).to have_content(warning_text)
end

Then('the key details include:') do |key_details_table|
  key_details = contract_page.key_details.native.text.split("\n").compact_blank.map(&:strip)

  key_details.zip(key_details_table.raw.flatten).each do |actual, expected|
    expect(actual).to include(expected)
  end
end

Then('I should see the following text within the contract offer history:') do |contract_offer_history_table|
  contract_offer_history = contract_page.contract_offer_history.native.text.split("\n").compact_blank.map(&:strip)

  contract_offer_history.zip(contract_offer_history_table.raw.flatten).each do |actual, expected|
    expect(actual).to include(expected)
  end
end

Then('the reason for not signing is:') do |reason_for_not_signing|
  expect(contract_page.reason_for_not_signing).to have_content("Your reason for not signing this contract offer was: ‘#{reason_for_not_signing.raw.flatten.join("\r ")}’.")
end

Then('I select {string} for the confirmation of signed contract') do |option|
  case option
  when 'Yes'
    contract_page.contract_option.contract_signed_yes.choose
  when 'No'
    contract_page.contract_option.contract_signed_no.choose
  end
end

Then('I enter {string} as the contract start date') do |date|
  add_contract_start_date(*date_options(date))
end

Then('I enter a contract start date {int} years and {int} months into the future') do |years, months|
  @contract_start_date = Time.zone.today + years.years + months.months

  add_contract_start_date(*@contract_start_date.strftime('%d/%m/%Y').split('/'))
end

Then('I enter {string} as the contract end date') do |date|
  add_contract_end_date(*date_options(date))
end

Then('I enter a contract end date {int} years and {int} months into the future') do |years, months|
  @contract_end_date = Time.zone.today + years.years + months.months

  add_contract_end_date(*@contract_end_date.strftime('%d/%m/%Y').split('/'))
end

Then('I enter the reason for not signing:') do |reason_for_not_signing|
  contract_page.contract_option.reason_for_not_signing.set(reason_for_not_signing.raw.flatten.join("\n"))
end

Then('the contract dates are correct on the contract signed page') do
  expect(contract_page.contract_signed_page.contract_dates).to have_content(contract_dates_description)
end

Then('the contract dates are correct for {string} on the procurement dashboard') do |contract_name|
  expect(procurement_page.send(:Contracts).find('a', text: contract_name).find(:xpath, '../../td[2]')).to have_content(format_date(@contract_start_date).squish)
  expect(procurement_page.send(:Contracts).find('a', text: contract_name).find(:xpath, '../../td[3]')).to have_content(format_date(@contract_end_date).squish)
end

Then('the contract dates are correct on the contract summary page') do
  expect(contract_page.key_details).to have_content(contract_dates_description)
end

Then('there is contract named {string} in {string}') do |contract_name, table|
  expect(procurement_page.send(table.to_sym)).to have_css('th', text: contract_name)
end

Then('I enter the reason for closing the contract:') do |reason_for_closing|
  contract_page.contract_option.reason_for_closing.set(reason_for_closing.raw.flatten.join("\n"))
end

Then('the reason for closing is:') do |reason_for_closing|
  expect(contract_page.reason_for_closing).to have_content("Your reason for closing this contract offer was: ‘#{reason_for_closing.raw.flatten.join("\r ")}’.")
end

Then('the what happens next {string} titles are:') do |option, what_happens_next_titles|
  page_what_happens_next_titles = case option
                                  when 'details'
                                    contract_page.what_happens_next_details_titles
                                  when 'list'
                                    contract_page.what_happens_next_list_titles
                                  end

  page_what_happens_next_titles.zip(what_happens_next_titles.raw.flatten).each do |element, title|
    expect(element).to have_content(title)
  end
end

Then('the contract summary footer has the following text:') do |summary_footer_table|
  summary_footer = contract_page.contract_summary_footer.native.text.split("\n").compact_blank.map(&:strip)

  summary_footer.zip(summary_footer_table.raw.flatten).each do |actual, expected|
    expect(actual).to include(expected)
  end
end

Then('the reason for declining is:') do |reason_for_declining|
  expect(contract_page.reason_for_declining).to have_content("The supplier’s reason for declining was: ‘#{reason_for_declining.raw.flatten.join("\r ")}’.")
end

def add_contract_start_date(day, month, year)
  contract_page.contract_option.contract_start_date_day.set(day)
  contract_page.contract_option.contract_start_date_month.set(month)
  contract_page.contract_option.contract_start_date_year.set(year)
end

def add_contract_end_date(day, month, year)
  contract_page.contract_option.contract_end_date_day.set(day)
  contract_page.contract_option.contract_end_date_month.set(month)
  contract_page.contract_option.contract_end_date_year.set(year)
end

def contract_dates_description
  "#{format_date @contract_start_date} and #{format_date @contract_end_date}".squish
end
