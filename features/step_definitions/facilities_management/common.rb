Given 'I sign in and navigate to my account' do
  visit facilities_management_new_user_session_path
  create_user_with_details
  fill_in 'email', with: @user.email
  fill_in 'password', with: nil
  click_on 'Sign in'
  expect(page.find('h1')).to have_content(@user.email)
end

Given('I have buildings') do
  create(:facilities_management_building, building_name: 'Test building', user: @user)
  create(:facilities_management_building_london, building_name: 'Test London building', user: @user)
end

Then 'I am on the {string} page' do |title|
  expect(page.find('h1')).to have_content(title)
end

Then 'I am on the page with secondary heading {string}' do |title|
  expect(page.find('h2')).to have_content(title)
end

Then('I should see the following secondary headings:') do |table|
  expect(page.all('h2').map(&:text)).to include(*table.transpose.raw.flatten)
end

When 'I click on {string}' do |button_text|
  click_on(button_text)
end

Then('the following content should be displayed on the page:') do |table|
  page_text = page.find('#main-content > div.govuk-width-container').text

  table.transpose.raw.flatten.each do |item|
    expect(page_text).to include(item)
  end
end

Then('I should see the following error messages:') do |table|
  expect(page).to have_css('div.govuk-error-summary')
  expect(page.find('.govuk-error-summary__list').find_all('a').map(&:text)).to eq table.transpose.raw.flatten
end
