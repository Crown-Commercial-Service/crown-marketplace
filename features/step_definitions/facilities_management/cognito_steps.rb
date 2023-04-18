Then 'I sign in with cognito' do
  fill_in 'email', with: @user_email
  fill_in 'password', with: 'ValidPassword'
  click_button 'Sign in'
end

Then 'I create an account with cognito' do
  fill_in 'Email address', with: @user_email
  fill_in "Create a password you'll remember", with: 'ValidPassword1!'
  fill_in 'Confirm your password', with: 'ValidPassword1!'
  click_on 'Create account'
end

Then 'I reset my password with cognito' do
  fill_in 'Email address', with: @user_email
  click_on 'Send reset email'
end

Then 'I click on the Sign in link' do
  page.find_by_id('main-content').click_on('Sign in')
end

When('my cookies are disabled') do
  if @javascript
    page.driver.browser.manage.delete_all_cookies
  else
    page.driver.browser.clear_cookies
  end
end

Then('I should sign in with the roles:') do |roles|
  stub_cognito(:existing_user, roles.raw.flatten)
  step 'I sign in with cognito'
end

Then('I should sign in with MFA and with the roles:') do |roles|
  stub_cognito(:sms_mfa, roles.raw.flatten)
  step 'I sign in with cognito'
end

Then('I should sign in for the first time with the roles:') do |roles|
  stub_cognito(:first_time_password_reset, roles.raw.flatten)
  step 'I sign in with cognito'
end

Then('I should sign in for the first time with MFA Enabled and with the roles:') do |roles|
  stub_cognito(:first_time_sms_mfa, roles.raw.flatten)
  step 'I sign in with cognito'
end

Then('I should sign in as user who just created their account and with the roles:') do |roles|
  stub_cognito(:first_time_confirm_account, roles.raw.flatten)
  step 'I sign in with cognito'
end

Then('I should sign in as a user who needs to reset their password and with the roles:') do |roles|
  stub_cognito(:password_reset_required, roles.raw.flatten)
  step 'I sign in with cognito'
end

Then('I can reset my password with the roles:') do |roles|
  stub_cognito(:forgot_password, roles.raw.flatten)
  step 'I reset my password with cognito'
end

Then('I am able to create an {string} account') do |service|
  stub_cognito(:create_an_account, ["#{service}_access", 'buyer'])
  step 'I create an account with cognito'
end

Then('I cannot reset my password becaue of the {string} error') do |error_key|
  stub_cognito_with_error(:forgot_password, error_key)
  step 'I reset my password with cognito'
end

Then('I cannot create an account becaue of the {string} error') do |error_key|
  stub_cognito_with_error(:create_an_account, error_key)
  step 'I create an account with cognito'
end

When('I cannot sign in becaue of the {string} error') do |error_key|
  stub_cognito_with_error(:sign_in, error_key)
  step 'I sign in with cognito'
end

When('I cannot sign in with MFA because of the {string} error and I have the following roles:') do |error_key, roles|
  stub_cognito_with_error(:sms_mfa, error_key, roles.raw.flatten)
  step 'I sign in with cognito'
end

When('I cannot sign in for the first time because of the {string} error and I have the following roles:') do |error_key, roles|
  stub_cognito_with_error(:first_time_password_reset, error_key, roles.raw.flatten)
  step 'I sign in with cognito'
end

When('I cannot sign in for the first time with MFA Enabled because of the {string} error and I have the following roles:') do |error_key, roles|
  stub_cognito_with_error(:first_time_sms_mfa, error_key, roles.raw.flatten)
  step 'I sign in with cognito'
end

When('I cannot sign in having just created my account because of the {string} error and I have the following roles:') do |error_key, roles|
  stub_cognito_with_error(:first_time_confirm_account, error_key, roles.raw.flatten)
  step 'I sign in with cognito'
end

When('I cannot sign in and reset my password because of the {string} error and I have the following roles:') do |error_key, roles|
  stub_cognito_with_error(:password_reset_required, error_key, roles.raw.flatten)
  step 'I sign in with cognito'
end
