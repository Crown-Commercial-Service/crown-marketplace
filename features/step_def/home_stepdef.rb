Given('I am a logged in user') do
  login_user
end

And(/^I click on "(.+)"$/) do |text|
  click_on text
end

And(/^I should see header "(.+)"$/) do |string|
  expect(page).to have_css('h1', text: string)
end

And(/^the following home page content is displayed:$/) do |table|
  table.transpose.raw.flatten.each do |item|
    expect(page).to have_css('#main-content > div.govuk-width-container', text: item)
  end
end
