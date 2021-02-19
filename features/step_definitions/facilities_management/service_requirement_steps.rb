Then('I choose to answer the service volume question for {string}') do |service|
  step "I choose to answer the first Service volume question for '#{service}'"
end

Then('I choose to answer the service standard question for {string}') do |service|
  service_standard_row(service).find('a').click
end

Then('I choose to answer the first Service volume question for {string}') do |service|
  service_volume_row(service).find('a').click
end

Then('I choose to answer the second Service volume question for {string}') do |service|
  service_requirement_page.service_volume_questions.all('td', text: service).last.find(:xpath, './parent::tr').find('a').click
end

Then('the volume for {string} is {int}') do |service, volume|
  expect(service_volume_row(service).find('td:nth-of-type(3)')).to have_content(volume)
end

Then('the standard for {string} is {string}') do |service, standard|
  expect(service_standard_row(service).find('td:nth-of-type(3)')).to have_content(standard)
end

def service_volume_row(service)
  service_requirement_page.service_volume_questions.first('td', text: service).find(:xpath, './parent::tr')
end

def service_standard_row(service)
  service_requirement_page.service_standard_questions.first('td', text: service).find(:xpath, './parent::tr')
end

def additional_service_volume_row(service)
  service_volume_row(service).find('+tr')
end

Then('the detail of requirement for {string} is as follows:') do |service, detail_of_requirement|
  expect(additional_service_volume_row(service)).to have_css('details > summary > span', text: 'Detail of requirement')
  expect(additional_service_volume_row(service).find('details > div > p').native.text).to eq detail_of_requirement.raw.flatten.join("\n")
end

Then('I enter {string} for the service volume') do |volume|
  page.find('input[type="text"]').set(volume)
end

Then('I enter {string} for the number of hours per year') do |volume|
  page.find('#facilities_management_procurement_building_service_service_hours').set(volume)
end

Then('I enter the following for the detail of requirement:') do |detail_of_requirement|
  page.find('#facilities_management_procurement_building_service_detail_of_requirement').set(detail_of_requirement.raw.flatten.join("\n"))
end

Then('I select Standard {string}') do |standard|
  page.find("#facilities_management_procurement_building_service_service_standard_#{standard.downcase}").choose
end

Then('I enter {string} for lift number {int}') do |number_of_floors, lift_number|
  raise if page.all('.number-of-floors').size < lift_number

  page.all('.number-of-floors')[lift_number - 1].set(number_of_floors)
end

Then('I add {int} lifts') do |number_of_lifts|
  number_of_lifts.times { service_requirement_page.add_lifts.click }
end

Then('I add {int} lift') do |number_of_lifts|
  number_of_lifts.times { service_requirement_page.add_lifts.click }
end

Then('lift {int} should have the error message {string}') do |lift_number, error_message|
  raise if service_requirement_page.lift_rows.size < lift_number

  expect(service_requirement_page.lift_rows[lift_number - 1].find('.govuk-error-message')).to have_content(error_message)
end

Then('there are {int} lift rows') do |lift_rows|
  expect(service_requirement_page.lift_rows.size).to eq lift_rows
end

Then('the add lift button has text {string}') do |button_text|
  expect(service_requirement_page.add_lifts).to have_content(button_text)
end

Then('I remove a lift') do
  service_requirement_page.all('.lift-row').last.find('.remove-lift-record').click
end

Then('I am on the Internal and external areas page in service requirements') do
  expect(service_requirement_page.first('h2')).to have_content('Internal and external areas')
end

Then('the service {string} should have the error message {string}') do |service, error_message|
  expect(additional_service_volume_row(service).find('td > span')).to have_content(error_message)
end

Then('the volume question is {string}') do |question|
  expect(service_requirement_page.volume_label).to have_content(question)
end

Then('the volume unit is {string}') do |unit|
  expect(service_requirement_page.volume_unit).to have_content(unit)
end
