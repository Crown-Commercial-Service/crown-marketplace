Then('I navigate to the supplier dashboard') do
  visit facilities_management_supplier_path
end

Given('I log in as a supplier with a contract in {string} named {string}') do |state, contract_name|
  create_supplier
  supplier = find_supplier
  supplier.update(user: @supplier_user)
  create_contract_for_supplier(contract_name, supplier, state)
  visit facilities_management_supplier_new_user_session_path
  update_banner_cookie(true) if @javascript
  fill_in 'email', with: @supplier_user.email
  fill_in 'password', with: nil
  click_on 'Sign in'
  expect(page.find('h1')).to have_content('Direct award dashboard')
end

Given('I logout and sign in the supplier {string}') do |email|
  step "I click on 'Sign out'"
  create_supplier_with_email(email)
  find_supplier.update(user: @supplier_user)
  visit facilities_management_supplier_new_user_session_path
  update_banner_cookie(true) if @javascript
  fill_in 'email', with: @supplier_user.email
  fill_in 'password', with: nil
  click_on 'Sign in'
  expect(page.find('h1')).to have_content('Direct award dashboard')
end

Given('I logout and sign in the supplier again') do
  step "I click on 'Sign out'"
  visit facilities_management_supplier_new_user_session_path
  fill_in 'email', with: @supplier_user.email
  fill_in 'password', with: nil
  click_on 'Sign in'
  expect(page.find('h1')).to have_content('Direct award dashboard')
end

Then('I should see the following contracts on the dashboard in the section:') do |contracts|
  contracts.raw.each do |contract|
    expect(supplier_page.supplier_tables.send(contract[0].to_sym).contract_names.map(&:text)).to include contract[1]
  end
end

Then('I respond to this contract offer with {string}') do |option|
  case option
  when 'Yes'
    supplier_page.respond_to_contract_yes.choose
  when 'No'
    supplier_page.respond_to_contract_no.choose
  end
end

Then('I should not see any contracts') do
  expect(supplier_page.supplier_tables.send(:'No received offers')).to have_content('You do not have any received offers')
  expect(supplier_page.supplier_tables.send(:'No accepted offers')).to have_content('You do not have any accepted offers')
  expect(supplier_page.supplier_tables.send(:'No contracts')).to have_content('You do not have any live contracts')
  expect(supplier_page.supplier_tables.send(:'No closed')).to have_content('You do not have any items in this section')
end

Then('I enter the reason for declining the contract:') do |reason_for_declining|
  supplier_page.reason_for_declining.set(reason_for_declining.raw.flatten.join("\n"))
end

Then('my reason for not declining is:') do |reason_for_declining|
  expect(contract_page.reason_for_declining).to have_content("Your reason for declining was: '#{reason_for_declining.raw.flatten.join("\r ")}'.")
end

Then('the buyers reason for not signing is:') do |reason_for_not_signing|
  expect(contract_page.reason_for_not_signing).to have_content("The buyer’s reason for not signing this contract was: '#{reason_for_not_signing.raw.flatten.join("\r ")}'.")
end

Then('the buyers reason for withdrawing is:') do |reason_for_closing|
  expect(contract_page.reason_for_closing).to have_content("The buyer’s reason for withdrawing this contract offer was: '#{reason_for_closing.raw.flatten.join("\r ")}'.")
end

def create_contract_for_supplier(contract_name, supplier, state)
  procurement = create(:facilities_management_procurement_completed_procurement_no_suppliers, user: (@user || create(:user, :with_detail)), contract_name: contract_name)

  procurement.procurement_suppliers.create(supplier: supplier, aasm_state: state, direct_award_value: 5000, offer_sent_date: Time.zone.today - 4.days, **PROCUREMENT_SUPPLIER_ATTRIBUTES[state.to_sym])
end
