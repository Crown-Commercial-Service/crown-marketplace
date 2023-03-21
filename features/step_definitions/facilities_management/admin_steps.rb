Given('I go to the admin dashboard for {string}') do |framework|
  visit "/facilities-management/#{framework}/admin/"

  expect(page.find('h1')).to have_content("#{framework} administration dashboard")
end

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
  expect(admin_page.supplier_details.send(:'Current user').detail).to have_content(@user.email)
end

Then('I enter {string} into the {string} field') do |supplier_detail, field|
  admin_page.supplier_detail_form.send(field.to_sym).set(supplier_detail)
end

Then('I enter {string} as the {string} date') do |date, date_type|
  add_management_report_dates(date_type, *date_options(date))
end

Then('the management report has the correct date range') do
  date_range = "The date range for this report is: #{Time.zone.yesterday.strftime('%d/%-m/%Y')} - #{Time.zone.today.strftime('%d/%-m/%Y')}"

  expect(admin_page.management_report_date).to have_content(date_range)
end

Then('there should be {int} management reports') do |number_of_management_reports|
  expect(admin_page.management_reports.length).to eq number_of_management_reports
end

def add_management_report_dates(date_type, day, month, year)
  admin_page.management_report.send("#{date_type} day").set(day)
  admin_page.management_report.send("#{date_type} month").set(month)
  admin_page.management_report.send("#{date_type} year").set(year)
end
