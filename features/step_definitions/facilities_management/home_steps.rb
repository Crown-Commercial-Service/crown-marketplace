When 'I go to the facilities management start page' do
  visit facilities_management_start_path
end

Then('I should sign in as an fm buyer without details') do
  create_user_without_details
  step 'I sign in'
end

Then('I should sign in as an fm buyer with details') do
  create_user_with_details
  step 'I sign in'
end

Then('I am on the Your account page') do
  expect(page.find('#main-content > div.govuk-width-container > div:nth-child(1) > div > span')).to have_content('Your account')
end

Then('I sign in') do
  fill_in 'email', with: @user.email
  fill_in 'password', with: nil
  click_on 'Sign in'
end

Then('the cookie banner {string} visible') do |option|
  case option
  when 'is'
    expect(page.find('#cookie-options-container')).to be_visible
  when 'is not'
    expect(page).not_to have_css('#cookie-options-container')
  end
end

Then('the cookie banner shows I have {string} the cookies') do |option|
  case option
  when 'accepted'
    expect(page.find('#cookies-accepted-container')).to be_visible
    expect(page.find('#cookies-rejected-container')).not_to be_visible
  when 'rejected'
    expect(page.find('#cookies-rejected-container')).to be_visible
    expect(page.find('#cookies-accepted-container')).not_to be_visible
  end
end

Then('the cookies have been {string}') do |option|
  expect(page.driver.browser.manage.cookie_named('crown_marketplace_cookie_settings_viewed')[:value]).to eq('true')

  case option
  when 'accepted'
    expect(page.driver.browser.manage.cookie_named('crown_marketplace_google_analytics_enabled')[:value]).to eq('true')
  when 'rejected'
    expect(page.driver.browser.manage.cookie_named('crown_marketplace_google_analytics_enabled')[:value]).to eq('false') if page.driver.browser.manage.all_cookies.find { |cookie| cookie[:name] == 'crown_marketplace_google_analytics_enabled' }
  end
end

Then('I choose to {string} cookies') do |option|
  case option
  when 'enable'
    page.find('#ga_cookie_usage_true').choose
  when 'disable'
    page.find('#ga_cookie_usage_false').choose
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
