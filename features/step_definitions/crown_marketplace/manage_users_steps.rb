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
