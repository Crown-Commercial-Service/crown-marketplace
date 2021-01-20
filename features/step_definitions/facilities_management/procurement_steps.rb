Then('I enter {string} into the contract name field') do |contract_name|
  @contract_name = contract_name
  procurement_page.contract_name_field.set(contract_name)
end

Then('I have a procurement with the name {string}') do |contract_name|
  create(:facilities_management_procurement, user: @user, contract_name: contract_name)
end

Then('I should see my procurement name') do
  expect(procurement_page.contract_name.text).to eq @contract_name
end

Then('{string} should have the status {string} in {string}') do |detail, status, section|
  expect(procurement_page.send(section).send(detail).status.text).to eq status.downcase
end

And('I select {string} for estimated annual cost known') do |option|
  if option == 'Yes'
    procurement_page.estimated_cost_known_yes.choose
  elsif option == 'No'
    procurement_page.estimated_cost_known_no.choose
  end
end

And('I enter {string} for estimated annual cost') do |estimated_annual_cost|
  procurement_page.estimated_cost_known.set(estimated_annual_cost)
end

Then('I select {string} for TUPE required') do |option|
  if option == 'Yes'
    procurement_page.tupe_yes.choose
  elsif option == 'No'
    procurement_page.tupe_no.choose
  end
end

Then('I enter {int} years for the contract period') do |years|
  procurement_page.initial_call_off_period_years.set(years)
end

Then('I enter {string} as the inital call-off period start date') do |date|
  date_parts = case date.downcase
               when 'today'
                 Time.zone.today.strftime('%d/%m/%Y')
               when 'yesterday'
                 Time.zone.yesterday.strftime('%d/%m/%Y')
               when 'tomorrow'
                 Time.zone.tomorrow.strftime('%d/%m/%Y')
               else
                 date
               end.split('/')

  procurement_page.initial_call_off_period_day.set(date_parts[0])
  procurement_page.initial_call_off_period_month.set(date_parts[1])
  procurement_page.initial_call_off_period_year.set(date_parts[2])
end

Then('I select {string} for mobilisation period required') do |option|
  if option == 'Yes'
    procurement_page.mobilisation_period_yes.choose
  elsif option == 'No'
    procurement_page.mobilisation_period_no.choose
  end
end

Then('I select {string} for optional extension required') do |option|
  if option == 'Yes'
    procurement_page.extension_required_yes.choose
  elsif option == 'No'
    procurement_page.extension_required_no.choose
  end
end

Then('I open all sections for the services') do
  step('I click on "Open all"') if @javascript
end

Then('I select the service {string}') do |service|
  page.check(service)
end

Then('I select the service code {string}') do |service|
  page.check("#facilities_management_procurement_service_codes_#{service.upcase.gsub('.', '-')}")
end

Then('I select the following services:') do |services|
  services.transpose.raw.flatten.each do |service|
    page.check(service)
  end
end

Then('I select the following service codes:') do |services|
  services.transpose.raw.flatten.each do |service|
    page.check("facilities_management_procurement_service_codes_#{service.upcase.gsub('.', '-')}")
  end
end

Then('I select all services for {string}') do |service_group|
  service_code = page.find("[data-sectionname='#{service_group}']")['data-section']
  page.check("#{service_code}_all")
end

Then('I should see the following seleceted services in the summary:') do |services_summary|
  expect(page.all('table > tbody > tr > td').map(&:text)).to match_array services_summary.transpose.raw.flatten
end

And('I find and select the building with the name {string}') do |building_name|
  continue = true

  while continue
    if page.text.include? building_name
      page.find('label', text: building_name).click
      continue = false
    elsif page.has_css?('.ccs-pagination') && first('.ccs-pagination')
      building.next_pagination.click
    else
      raise("Cannot find Building with name #{building_name}")
    end
  end
end

Then('I find and select the following buildings:') do |building_names|
  building_names.transpose.raw.flatten.each do |building_name|
    step "I find and select the building with the name '#{building_name}'"
  end
end

Then('I should see the following seleceted buildings in the summary:') do |buildings_summary|
  expect(page.all('table > tbody > tr > th').map(&:text)).to match_array buildings_summary.transpose.raw.flatten
end

Then('I select all services for the building') do
  page.check('box-all')
end

Then('I select all services for the building no js') do
  page.all('input[type="checkbox"]').each(&:check)
end

Then('I select the service {string} for the building') do |service|
  page.check(service)
end

Then('I select the service code {string} for the building') do |service|
  page.check("facilities_management_procurement_building_service_codes_#{service.downcase.gsub('.', '')}")
end

Then('I select the following services for the building:') do |services|
  services.transpose.raw.flatten.each do |service|
    page.check(service)
  end
end

Then('I select the following service codes for the building:') do |services|
  services.transpose.raw.flatten.each do |service|
    page.check("facilities_management_procurement_building_service_codes_#{service.downcase.gsub('.', '')}")
  end
end

Then('I choose to answer the Service volume question for {string}') do |service|
  step "I choose to answer the first Service volume question for '#{service}'"
end

Then('I choose to answer the Service standard question for {string}') do |service|
  answer_service_question(procurement_page.service_standard_questions, service)
end

Then('I choose to answer the first Service volume question for {string}') do |service|
  answer_service_question(procurement_page.service_volume_questions, service)
end

def answer_service_question(section, service)
  section.first('td', text: service).find(:xpath, './parent::tr').find('a').click
end

Then('I choose to answer the second Service volume question for {string}') do |service|
  procurement_page.service_volume_questions.all('td', text: service).last.find(:xpath, './parent::tr').find('a').click
end

Then('I enter {string} for the service volume') do |volume|
  page.find('input[type="text"]').set(volume)
end

Then('I enter {string} for the number of hours per year') do |volume|
  page.find('#facilities_management_procurement_building_service_service_hours').set(volume)
end

Then('I enter the following for the detail of requirement:') do |detail_of_requirement|
  page.find('#facilities_management_procurement_building_service_detail_of_requirement').set(detail_of_requirement.transpose.raw.flatten.join("\n"))
end

Then('I select Standard {string}') do |standard|
  page.find("#facilities_management_procurement_building_service_service_standard_#{standard.downcase}").choose
end

Then('the building should have the status {string}') do |status|
  expect(procurement_page.building_status.text).to eq status
end

And('everything is completed') do
  expect(page.all('td > strong').all? { |status| status.text == 'completed' }).to be true
end

Then('Direct award is an available route to market') do
  expect(procurement_page.has_direct_award_route_to_market?).to be true
end

Then('I select {string} on results') do |option|
  case option.downcase
  when 'direct award'
    procurement_page.direct_award_route_to_market.choose
  when 'further competition'
    procurement_page.further_competition_route_to_market.choose
  end
end
