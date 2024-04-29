Given('the {string} framework has expired') do |framework|
  Framework.find_by(framework:).update(expires_at: 1.day.ago)
end

Then('I should see the following warning text:') do |warning_text_table|
  expect(page.find('strong.govuk-warning-text__text')).to have_content("Warning#{warning_text_table.raw.flatten.first}")
end

Then('there are no text inputs') do
  expect(page.all('input[type="text"]')).to be_empty
end

Given('there are no checkbox inputs') do
  expect(page.all('input[type="checkbox"]')).to be_empty
end

Then('there is no submit button') do
  expect(page).to have_no_field(type: :submit)
end

Then('I cannot change the supplier details') do
  expect(page).to have_no_css('dd.govuk-summary-list__actions')
end
