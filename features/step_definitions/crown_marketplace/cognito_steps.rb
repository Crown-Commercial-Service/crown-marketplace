Then('I have an existing user in cognito with email {string}') do |email|
  stub_admin_cognito(:list_users, search_email: email, resp_email: email)
end

Then('I do not have an existing user in cognito with email {string}') do |email|
  stub_admin_cognito(:list_users, search_email: email)
end

Then('I am able to create a user account with:') do |user_account_details_table|
  user_account_details = user_account_details_table.raw.to_h.symbolize_keys

  stub_admin_cognito(:create_user, **user_account_details)
end

Given('I am going to do a search to find users') do
  stub_admin_cognito(:find_users)
end

Given('I search for {string} and there are no users') do |search|
  stub_admin_cognito(:find_users, search: search, users: [])
end

Given('I search for {string} there are the following users:') do |search, user_details|
  stub_admin_cognito(:find_users, search: search, users: user_details.raw.map { |user_detail| { email: user_detail[0], account_status: user_detail[1] == 'enabled' } })
end

Then('I cannot create a user account because of the {string} error') do |error_key|
  stub_cognito_admin_with_error(:create_user, error_key)
end

Then('I cannot find any user accounts because of the {string} error') do |error_key|
  stub_cognito_admin_with_error(:find_users, error_key)
end

Then('I cannot view the user account because of the {string} error') do |error_key|
  stub_cognito_admin_with_error(:find_user, error_key)
end

Then('I cannot edit the user account because of an error') do
  allow(Cognito::Admin::UserClientInterface).to receive(:find_user_from_cognito_uuid).and_return({ error: 'An error occured when trying to edit the user' })
end

Then('I cannot update the user account because of an error') do
  allow(Cognito::Admin::UserClientInterface).to receive(:update_user_and_return_errors).and_return('An error occured when trying to update the user')
end

Given('I search for {string} and there is a user with the following details:') do |email, user_details_table|
  stub_admin_cognito(:find_users, search: email, users: [{ email: email, account_status: 'enabled' }])

  user_details = user_details_table.raw.to_h
  @user_details = {
    cognito_uuid: SecureRandom.uuid,
    email: email,
    telephone_number: user_details['Mobile telephone number'],
    account_status: user_details['Account enabled'] == 'true',
    confirmation_status: user_details['Confirmation status'],
    mfa_enabled: user_details['MFA enabled'] == 'true',
    roles: (user_details['Roles'] || '').split(','),
    service_access: (user_details['Service access'] || '').split(',')
  }
  allow(Cognito::Admin::UserClientInterface).to receive(:find_user_from_cognito_uuid).and_return(@user_details)
end

Then('I am going to succesfully update the user on {string}') do |section|
  allow(Cognito::Admin::UserClientInterface).to receive(:update_user_and_return_errors).with(
    @user_details[:cognito_uuid],
    {
      email: @user_details[:email],
      account_status: @user_details[:account_status],
      telephone_number: @user_details[:telephone_number],
      groups: @user_details[:service_access] + @user_details[:roles],
      origional_groups: @user_details[:service_access] + @user_details[:roles],
      mfa_enabled: @user_details[:mfa_enabled]
    },
    section.to_sym
  ).and_return(nil)
end

Then('the users details after the update will be:') do |user_details_table|
  user_details = user_details_table.raw.to_h
  @user_details = {
    cognito_uuid: @user_details[:cognito_uuid],
    email: @user_details[:email],
    telephone_number: user_details['Mobile telephone number'] || @user_details[:telephone_number],
    account_status: user_details['Account enabled'] == 'true' || @user_details[:account_status] == 'true',
    confirmation_status: user_details['Confirmation status'] || @user_details[:confirmation_status],
    mfa_enabled: user_details['MFA enabled'] == 'true' || @user_details[:mfa_enabled] == 'true',
    roles: (user_details['Roles'] || '').split(',').presence || @user_details[:roles],
    service_access: (user_details['Service access'] || '').split(',').presence || @user_details[:service_access]
  }
  allow(Cognito::Admin::UserClientInterface).to receive(:find_user_from_cognito_uuid).and_return(@user_details)
end
