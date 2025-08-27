Given 'I sign in and navigate to my account for {string}' do |framework|
  visit "/facilities-management/#{framework}/sign-in"
  update_banner_cookie(true) if @javascript
  create_user_with_details
  step 'I sign in'
  expect(page.find('h1')).to have_content(@user.email)
end

# There is an issue where this will sometimes raise a
# undefined method `gsub' for nil:NilClass (NoMethodError)
# I'm not exactly sure why this happens but adding the rescue
# To try again does seem to sort it out
Then 'I am on the {string} page' do |title|
  expect(page.find('h1')).to have_content(title)
rescue NoMethodError
  expect(page.find('h1')).to have_content(title)
end

When 'I click on {string}' do |button_text|
  click_on(button_text)
end

Then('the following content should be displayed on the page:') do |table|
  page_text = page.find_by_id('main-content').text

  table.raw.flatten.each do |item|
    expect(page_text).to include(item)
  end
end

Then('I should see the following error messages:') do |table|
  expect(page).to have_css('div.govuk-error-summary')
  expect(page.find('.govuk-error-summary__list').find_all('a').map(&:text).reject(&:empty?)).to eq table.raw.flatten
end

Then('I open the {string} details') do |summary_text|
  page.find('details > summary', text: summary_text).click
end

Then('I enter the following details into the form:') do |table|
  table.raw.to_h.each do |field, value|
    fill_in field, with: value
  end
end

Given('I click on the {string} back link') do |link_text|
  page.find('.govuk-back-link', text: link_text).click
end

When('I navigate to the procurement {string}') do |contract_name|
  procurement_page.view_procurements.click
  step "I click on '#{contract_name}'"
end

Then('I am on a {string} page') do |option|
  expect(page.find('.govuk-service-navigation__service-name')).to have_content(PAGE_HEADING[option])
end

Then('I show all sections') do
  step('I click on "Show all sections"') if @javascript
end

Then('I select {string}') do |item|
  page.check(item)
end

Then 'I choose the {string} radio button' do |option|
  page.choose(option)
end

Then('I select the following items:') do |items|
  items.raw.flatten.each do |item|
    page.check(item)
  end
end

Then('I click on the {string} button') do |button_text|
  page.click_button(button_text, class: 'govuk-button')
end

Then('I click on the {string} link') do |link_text|
  page.click_link(link_text)
end

Then('I refresh the page') do
  refresh
end

When('I visit {string}') do |url|
  visit url
end

Then('the spreadsheet {string} is downloaded') do |spreadsheet_name|
  expect(page.response_headers['Content-Type']).to eq 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  expect(page.response_headers['Content-Disposition']).to include "filename=\"#{spreadsheet_name}".gsub('(', '%28').gsub(')', '%29')
end

Then('I pause') do
  # binding.pry
  pending 'This step is used for debugging features'
end

PAGE_HEADING = {
  'buyer' => 'Find a facilities management supplier',
  'supplier' => 'Facilities management supplier account',
  'admin' => 'Managing framework and supplier data'
}.freeze
