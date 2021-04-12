Given('I logout and sign in the supplier {string}') do |email|
  step "I click on 'Sign out'"
  create_supplier(email)
  FacilitiesManagement::SupplierDetail.find('ca57bf4c-e8a5-468a-95f4-39fcf730c770').update(user: @supplier_user)
  visit facilities_management_supplier_new_user_session_path
  fill_in 'email', with: @supplier_user.email
  fill_in 'password', with: nil
  click_on 'Sign in'
  expect(page.find('h1')).to have_content('Direct award dashboard')
end

Then('the supplier name is {string}') do |supplier_name|
  expect(direct_award_page.supplier_name).to have_content(supplier_name)
  expect(direct_award_page.supplier_contact_details.supplier_name).to have_content(supplier_name)
end

Then('the supplier details are:') do |supplier_details|
  contact_details = direct_award_page.supplier_contact_details.details

  supplier_details.raw.flatten.each do |supplier_detail|
    expect(contact_details).to have_content supplier_detail
  end
end

Then('I should see the following contracts in the table in the correct state:') do |contracts|
  contracts.raw.each do |contract|
    expect(direct_award_page.supplier_tables.send(contract[0].to_sym).contract_names.map(&:text)).to include contract[1]
  end
end

Then('I navigate to the supplier dashboard') do
  visit facilities_management_supplier_path
end

Given('I logout and sign in the supplier again') do
  step "I click on 'Sign out'"
  visit facilities_management_supplier_new_user_session_path
  fill_in 'email', with: @supplier_user.email
  fill_in 'password', with: nil
  click_on 'Sign in'
  expect(page.find('h1')).to have_content('Direct award dashboard')
end

Then('I should not see any contracts') do
  expect(direct_award_page.supplier_tables.send(:'No received offers')).to have_content('You do not have any received offers')
  expect(direct_award_page.supplier_tables.send(:'No accepted offers')).to have_content('You do not have any accepted offers')
  expect(direct_award_page.supplier_tables.send(:'No contracts')).to have_content('You do not have any live contracts')
  expect(direct_award_page.supplier_tables.send(:'No closed')).to have_content('You do not have any items in this section')
end
