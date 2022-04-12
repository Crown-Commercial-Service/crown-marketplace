Given('I sign in as an admin and navigate to the {string} dashboard') do |framework|
  @framework = framework
  visit "/facilities-management/#{framework}/admin/sign-in"
  update_banner_cookie(true) if @javascript
  create_admin_user_with_details
  fill_in 'email', with: @user.email
  fill_in 'password', with: 'ValidPassword'
  click_on 'Sign in'
  expect(page.find('h1')).to have_content("#{framework} administration dashboard")
end

Given('I go to the facilities management {string} admin start page') do |framework|
  visit "/facilities-management/#{framework}/admin/sign-in"
  update_banner_cookie(true) if @javascript
end

Then('the supplier name on the details page is {string}') do |supplier_name|
  expect(admin_page.supplier_details.supplier_name_title).to have_content(supplier_name)
end

Then('I change the {string} for the supplier details') do |supplier_detail|
  admin_page.supplier_details.send(supplier_detail.to_sym).change_link.click
end

Then('the {string} is {string} on the supplier details page') do |supplier_detail, text|
  expect(admin_page.supplier_details.send(supplier_detail.to_sym).detail).to have_content(text)
end

Then('the current user has the user email') do
  expect(admin_page.supplier_details.send(:'Current user'.to_sym).detail).to have_content(@user.email)
end

Then('I enter {string} into the {string} field') do |supplier_detail, field|
  current_admin_page = case @framework
                       when 'RM3830'
                         admin_rm3830_page
                       when 'RM6232'
                         admin_rm6232_page
                       end

  current_admin_page.supplier_detail_form.send(field.to_sym).set(supplier_detail)
end
