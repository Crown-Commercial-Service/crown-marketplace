Given('I sign in as an admin and navigate to the {string} dashboard') do |framework|
  visit "/facilities-management/#{framework}/admin/sign-in"
  update_banner_cookie(true) if @javascript
  create_admin_user_with_details
  fill_in 'email', with: @user.email
  fill_in 'password', with: 'ValidPassword'
  click_on 'Sign in'
  expect(page.find('h1')).to have_content("#{framework} administration dashboard")
end

Given('I go to the facilities management {string} admin start page') do |framework|
  visit "/facilities-management/#{framework}/admin/sign-in"
  update_banner_cookie(true) if @javascript
end
