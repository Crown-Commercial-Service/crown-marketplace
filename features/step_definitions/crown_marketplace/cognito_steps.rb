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

Then('I cannot create a user account because of the {string} error') do |error_key|
  stub_cognito_admin_with_error(:create_user, error_key)
end
