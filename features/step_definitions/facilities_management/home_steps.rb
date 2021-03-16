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
