Given('the {string} framework has expired') do |framework|
  Framework.find_by(framework:).update(expires_at: 1.day.ago)
end

Then('I should see the following warning text:') do |warning_text_table|
  expect(page.find('strong.govuk-warning-text__text')).to have_content("Warning#{warning_text_table.raw.flatten.first}")
end

Then('all the text inputs are disabled') do
  expect(page.all('input[type="text"]')).to be_all(&:disabled?)
end

Given('all the checkbox inputs are disabled') do
  expect(page.all('input[type="checkbox"]')).to be_all(&:disabled?)
end

Then('the submit button is disabled') do
  expect(page.find('input[type="submit"]')).to be_disabled
end

Then('I cannot change the supplier details') do
  expect(page).not_to have_css('dd.govuk-summary-list__actions')
end
