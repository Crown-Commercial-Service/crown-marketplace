Then('the legend is {string}') do |legend_text|
  expect(page.find('fieldset > legend')).to have_content(legend_text)
end

Then('the {string} in the summary is:') do |option, details|
  details.raw.flatten.each do |detail|
    expect(manage_users_page.user_details_summary.send(option).value).to have_content(detail)
  end
end

Then('the account {string} has been added') do |email|
  expect(manage_users_page.notification_banner.heading).to have_content('User account created')
  expect(manage_users_page.notification_banner.content).to have_content("An email has been sent to #{email} with the details for them to sign in")
end

Then('I change the {string} from the user summary') do |option|
  manage_users_page.user_details_summary.send(option).action.click
end

Then('I should see the following error for finding a user:') do |error_message|
  expect(manage_users_page.find_a_user.error).to have_content(error_message.raw.flatten.first)
end

Then('I enter {string} into the search') do |search|
  manage_users_page.find_a_user.search.set(search)
end

Given('I should see that there are no users with that email address') do
  expect(manage_users_page.find_a_user_table.no_users).to have_content('No users were found with that email address')
end

Then('I should see the following users in the results:') do |found_users_table|
  found_users = found_users_table.raw
  found_users_rows = manage_users_page.find_a_user_table.rows

  expect(found_users.length).to eq(found_users_rows.length)

  found_users_rows.zip(found_users).each do |user_row, user_detail|
    expect(user_row.email).to have_content(user_detail[0])
    expect(user_row.status).to have_content(user_detail[1])
  end
end
