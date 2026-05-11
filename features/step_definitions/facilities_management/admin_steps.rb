Given('I go to the admin dashboard for {string}') do |framework|
  visit "/facilities-management/#{framework}/admin/"

  expect(page.find('h1')).to have_text("#{framework} administration dashboard")
end

Given('I sign in as an admin and navigate to the {string} dashboard') do |framework|
  @framework = framework
  visit "/facilities-management/#{framework}/admin/sign-in"
  update_banner_cookie(true) if @javascript
  create_admin_user_with_details
  step 'I sign in'
  expect(page.find('h1')).to have_text("#{framework} administration dashboard")
end

Given('I sign in as an admin for the {string} framework in {string}') do |framework, _service|
  @framework = framework
  visit "/facilities-management/#{framework}/admin/sign-in"
  update_banner_cookie(true) if @javascript
  create_admin_user_with_details
  step 'I sign in'
  step "I am on the 'Admin dashboard' page"
end

Given('I go to the facilities management {string} admin start page') do |framework|
  visit "/facilities-management/#{framework}/admin/sign-in"
  update_banner_cookie(true) if @javascript
end

Then('the supplier name on the details page is {string}') do |supplier_name|
  expect(admin_page.supplier_details.supplier_name_title).to have_text(supplier_name)
end

Then('I change the {string} for the supplier details') do |supplier_detail|
  admin_page.supplier_details.send(supplier_detail.to_sym).change_link.click
end

Then('the {string} is {string} on the supplier details page') do |supplier_detail, text|
  expect(admin_page.supplier_details.send(supplier_detail.to_sym).detail).to have_text(text)
end

Then('I enter {string} into the {string} field') do |supplier_detail, field|
  admin_page.supplier_detail_form.send(field.to_sym).set(supplier_detail)
end

Then('I enter {string} as the {string} date') do |date, date_type|
  add_management_report_dates(date_type, *date_options(date))
end

Then('the management report has the correct date range') do
  date_range = "The date range for this report is: #{Time.zone.yesterday.strftime('%d/%m/%Y')} - #{Time.zone.today.strftime('%d/%m/%Y')}"

  expect(admin_page.management_report_date).to have_text(date_range)
end

Then('there should be {int} management reports') do |number_of_management_reports|
  expect(admin_page.management_reports.length).to eq number_of_management_reports
end

Then('I should see the following details in the {string} summary:') do |summary, supplier_data|
  summary_rows = admin_page.send(summary)

  expect(summary_rows.length).to eq(supplier_data.raw.length)

  summary_rows.zip(supplier_data.raw).each do |section, (expected_key, expected_value)|
    expect(section.key).to have_text(expected_key)
    expect(section.value).to have_text(expected_value)
  end
end

Then('I should see the following details in the summary for the lot {string}:') do |lot_name, supplier_data|
  summary_rows = admin_page.supplier_lots.find { |element| element.lot_name.text == lot_name }.lot_info

  expect(summary_rows.length).to eq(supplier_data.raw.length)

  summary_rows.zip(supplier_data.raw).each do |section, (expected_key, expected_value)|
    expect(section.key).to have_text(expected_key)
    expect(section.value).to have_text(expected_value)
  end
end

Then('I click on {string} for the lot {string}') do |view_link_text, lot_name|
  admin_page.supplier_lots.find { |element| element.lot_name.text == lot_name }.lot_info.find { |section| section.value.text.starts_with?(view_link_text) }.find('a').click
end

Then('the supplier should be assigned to the {string} as follows:') do |_section, section_items|
  admin_check_section_items(
    admin_page.supplier_section_summaries.first.section_items.first,
    section_items
  )
end

Then('the supplier should be assigned to the {string} in {string} as follows:') do |_section, category, section_items|
  admin_check_section_items(
    admin_page.supplier_section_summaries.first.section_items.find { |section| section.heading.text == category },
    section_items
  )
end

Then('the supplier should not be assigned any {string} with the following message:') do |_section, empty_message|
  expect(admin_page.supplier_section_summaries.first.empty_message).to have_text(empty_message.raw.flatten.first)
end

def add_management_report_dates(date_type, day, month, year)
  admin_page.management_report.send("#{date_type} day").set(day)
  admin_page.management_report.send("#{date_type} month").set(month)
  admin_page.management_report.send("#{date_type} year").set(year)
end

def admin_check_section_items(summary, section_items)
  items = summary.items
  expected_items = section_items.raw.flatten.compact.compact_blank

  expect(items.length).to eq(expected_items.length)

  items.zip(expected_items).each do |item, expected_value|
    expect(item).to have_text(expected_value)
  end
end
