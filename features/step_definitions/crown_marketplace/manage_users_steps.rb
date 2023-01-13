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

Then('I view the user with email {string}') do |email|
  manage_users_page.find_a_user_table.rows.find { |row| row.email.has_content? email }.view.click
end

Then('I can manage the user') do
  expect(manage_users_page).not_to have_css('strong.govuk-warning-text__text')
end

Then('I cannot manage the user and there is the following warning:') do |warning_text|
  expect(manage_users_page.view_user_warning).to have_content("Warning#{warning_text.raw.flatten.first}")
end

Then('the user has the following details:') do |user_details_table|
  user_details = user_details_table.raw.to_h.symbolize_keys

  user_details.each do |key, value|
    user_details_row = manage_users_page.view_user_summary.send(key)

    expect(user_details_row.key).to have_content(key.to_s)
    expect(user_details_row.value).to have_content(value)
  end
end

Then('I can see the following error message in the summary:') do |table|
  expect(page).to have_css('div.govuk-error-summary')
  expect(page.find('.govuk-error-summary__list').find_all('li').map(&:text).reject(&:empty?)).to eq table.raw.flatten
end
