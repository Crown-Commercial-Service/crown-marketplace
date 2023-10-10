Given('I sign in without details for {string}') do |framework|
  visit "/facilities-management/#{framework}/sign-in"
  update_banner_cookie(true) if @javascript
  create_user_without_details
  fill_in 'email', with: @user.email
  fill_in 'password', with: 'ValidPassword'
  click_on 'Sign in'
  expect(page.find('h1')).to have_content('Manage your details')
end

Then('I should sign in as an fm buyer without details') do
  create_user_without_details
  step 'I sign in'
end

Then('I should sign in as an fm buyer with details') do
  create_user_with_details
  step 'I sign in'
end

When('I go to the {string} not permitted page for {string}') do |user_type, framework|
  not_permitted_path_base = "/facilities-management/#{framework}/"
  not_permitted_path_base += user_type unless user_type == 'buyer'

  visit "#{not_permitted_path_base}/not-permitted"
end

Then('I sign in') do
  fill_in 'email', with: @user.email
  fill_in 'password', with: 'ValidPassword'
  click_on 'Sign in'
end

Then('the cookie banner {string} visible') do |option|
  case option
  when 'is'
    expect(page.find_by_id('cookie-options-container')).to be_visible
  when 'is not'
    expect(page).not_to have_css('#cookie-options-container')
  end
end

Then('the cookie banner shows I have {string} the cookies') do |option|
  case option
  when 'accepted'
    expect(page.find_by_id('cookies-accepted-container')).to be_visible
    expect(page.find_by_id('cookies-rejected-container')).not_to be_visible
  when 'rejected'
    expect(page.find_by_id('cookies-rejected-container')).to be_visible
    expect(page.find_by_id('cookies-accepted-container')).not_to be_visible
  end
end

Then('the cookies have been saved') do
  expect(cookie_settings['settings_viewed']).to be true
end

Then('the {string} cookies have been {string}') do |cookie, option|
  case option
  when 'accepted'
    expect(cookie_settings[COOKIE_TO_OPTION[cookie]]).to be true
  when 'rejected'
    expect(cookie_settings[COOKIE_TO_OPTION[cookie]]).to be false
  end
end

Then('I choose to {string} {string} cookies') do |option, cookie|
  case option
  when 'enable'
    page.find("##{cookie}_cookie_usage_true").choose
  when 'disable'
    page.find("##{cookie}_cookie_usage_false").choose
  end
end

Given('I enter {string} for my email') do |email|
  fill_in 'email', with: email
end

Given('I enter {string} for the password') do |password|
  fill_in 'password01', with: password
end

Given('I enter {string} for the password confirmation') do |password_confirmation|
  fill_in 'password02', with: password_confirmation
end

Then('there are no header navigation links') do
  expect(home_page.navigation.links).to be_empty
end

Then('I should see the following navigation links:') do |navigation_links|
  home_page.navigation.links.zip(navigation_links.raw.flatten).each do |actual, expected|
    expect(actual).to have_content expected
  end
end

Then('the header navigation links {string} visible') do |option|
  case option
  when 'are'
    expect(home_page.navigation).to be_visible
  when 'are not'
    expect(home_page.navigation).to_not be_visible
  end
end

COOKIE_TO_OPTION = {
  'ga' => 'usage',
  'glassbox' => 'glassbox'
}.freeze

def cookie_settings
  JSON.parse(CGI.unescape(page.driver.browser.manage.cookie_named('cookie_preferences')[:value]))
end
