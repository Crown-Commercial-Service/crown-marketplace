Given 'I sign in and navigate to my account for {string}' do |framework|
  visit "/facilities-management/#{framework}/sign-in"
  update_banner_cookie(true) if @javascript
  create_user_with_details
  fill_in 'email', with: @user.email
  fill_in 'password', with: 'ValidPassword'
  click_on 'Sign in'
  expect(page.find('h1')).to have_content(@user.email)
end

Given('I have buildings') do
  create(:facilities_management_building, building_name: 'Test building', user: @user)
  create(:facilities_management_building_london, building_name: 'Test London building', user: @user)
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

Then 'I am on the page with secondary heading {string}' do |title|
  expect(page.find('h2')).to have_content(title.to_s)
end

Then('I should see the following secondary headings:') do |table|
  expect(page.all('h2').map(&:text)).to include(*table.raw.flatten)
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

Then('I navigate to the building summary page for {string}') do |building_name|
  visit "/facilities-management/#{@framework}/buildings/"
  click_on building_name
  step "I am on the buildings summary page for '#{building_name}'"
end

Given('I click on the {string} return link') do |link_text|
  page.find('.govuk-link, .govuk-link--no-visited-state', text: link_text).click
end

Given('I click on the {string} back link') do |link_text|
  page.find('.govuk-back-link', text: link_text).click
end

When('I navigate to the procurement {string}') do |contract_name|
  procurement_page.view_procurements.click
  step "I click on '#{contract_name}'"
end

And('I click on the button with text {string}') do |button_text|
  page.find("input[value='#{button_text}']").send_keys(:return)
end

And('I click on the link with text {string}') do |button_text|
  page.find('a', text: button_text).send_keys(:return)
end

Then('I am on a {string} page') do |option|
  expect(page.find('#wrapper > header > div > div.govuk-header__content > div')).to have_content(PAGE_HEADING[option])
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

Then('I refresh the page') do
  refresh
end

When('I visit {string}') do |url|
  visit url
end

Then('the framework is {string}') do |framework|
  expect(page).to have_current_path(%r{/facilities-management/#{framework}/*})
end

Then('the spreadsheet {string} is downloaded') do |spreadsheet_name|
  expect(page.response_headers['Content-Type']).to eq 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  expect(page.response_headers['Content-Disposition']).to include "filename=\"#{spreadsheet_name}".gsub('(', '%28').gsub(')', '%29')
end

And('I start a procurement') do
  step "I click on 'Start a procurement'"
  step "I am on the 'What happens next' page"
  step "I click on 'Continue'"
  step "I am on the 'Contract name' page"
  step "I enter 'Test procurement' into the contract name field"
  step "I click on 'Save and continue'"
  step "I am on the 'Requirements' page"
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
