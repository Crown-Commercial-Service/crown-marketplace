Given('I sign in as an {string} user go to the crown marketplace dashboard') do |user|
  visit '/crown-marketplace/sign-in'
  update_banner_cookie(true) if @javascript
  create_admin_user(user)
  step 'I sign in'
  expect(page.find('h1')).to have_content('Crown Marketplace dashboard')
end

Given('I go to the crown marketplace start page') do
  visit '/crown-marketplace/sign-in'
  update_banner_cookie(true) if @javascript
end

Given('I go to the crown marketplace not permitted page') do
  visit 'crown-marketplace/not-permitted'
end
