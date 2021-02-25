Then('{string} should have the status {string} in {string}') do |detail, status, section|
  expect(entering_requirements_page.send(section).send(detail).status.text).to eq status.downcase
end

And('I select {string} for estimated annual cost known') do |option|
  if option == 'Yes'
    entering_requirements_page.estimated_cost_known_yes.choose
  elsif option == 'No'
    entering_requirements_page.estimated_cost_known_no.choose
  end
end

And('I enter {string} for estimated annual cost') do |estimated_annual_cost|
  entering_requirements_page.estimated_cost_known.set(estimated_annual_cost)
end

Then('I select {string} for TUPE required') do |option|
  if option == 'Yes'
    entering_requirements_page.tupe_yes.choose
  elsif option == 'No'
    entering_requirements_page.tupe_no.choose
  end
end

Then('I enter {string} years and {string} months for the contract period') do |years, months|
  add_contract_period(years, months)
end

Then('I enter {string} year and {string} month for the contract period') do |years, months|
  add_contract_period(years, months)
end

Then('I enter {string} year and {string} months for the contract period') do |years, months|
  add_contract_period(years, months)
end

Then('I enter {string} years and {string} month for the contract period') do |years, months|
  add_contract_period(years, months)
end

def add_contract_period(years, months)
  @contract_period_years = years.to_i
  @contract_period_months = months.to_i

  entering_requirements_page.initial_call_off_period_years.set(years)
  entering_requirements_page.initial_call_off_period_months.set(months)
end

Then('I enter {string} as the inital call-off period start date') do |date|
  add_initial_call_off_period_dates(*case date.downcase
                                     when 'today'
                                       Time.zone.today.strftime('%d/%m/%Y')
                                     when 'yesterday'
                                       Time.zone.yesterday.strftime('%d/%m/%Y')
                                     when 'tomorrow'
                                       Time.zone.tomorrow.strftime('%d/%m/%Y')
                                     else
                                       date
                                     end.split('/'))
end

Then('I enter an inital call-off period start date {int} years and {int} months into the future') do |years, months|
  @initial_call_off_period_start_date = Time.zone.today + years.years + months.months

  add_initial_call_off_period_dates(*@initial_call_off_period_start_date.strftime('%d/%m/%Y').split('/'))
end

def add_initial_call_off_period_dates(day, month, year)
  entering_requirements_page.initial_call_off_period_day.set(day)
  entering_requirements_page.initial_call_off_period_month.set(month)
  entering_requirements_page.initial_call_off_period_year.set(year)
end

Then('I select {string} for mobilisation period required') do |option|
  if option == 'Yes'
    entering_requirements_page.mobilisation_period_yes.choose
  elsif option == 'No'
    entering_requirements_page.mobilisation_period_no.choose
  end
end

Then('I enter {string} weeks for the mobilisation period') do |mobilisation_period|
  @mobilisation_period = mobilisation_period.to_i

  entering_requirements_page.mobilisation_period.set(mobilisation_period)
end

Then('I select {string} for optional extension required') do |option|
  if option == 'Yes'
    entering_requirements_page.extension_required_yes.choose
  elsif option == 'No'
    entering_requirements_page.extension_required_no.choose
  end
end

And('only the first optional extension is required') do
  entering_requirements_page.optional_call_off_extensions.send(:'1').required.set(true)
end

Then('I enter {string} years and {string} months for optional extension {int}') do |years, months, extension|
  @contract_extentsions ||= {}
  @contract_extentsions[extension] = years.to_i.years + months.to_i.months

  entering_requirements_page.optional_call_off_extensions.send(:"#{extension}").years.set(years)
  entering_requirements_page.optional_call_off_extensions.send(:"#{extension}").months.set(months)
end

Then('I add another extension') do
  entering_requirements_page.optional_call_off_extensions.add_extension.click
end

Then('I remove extension period {int}') do |extension|
  entering_requirements_page.optional_call_off_extensions.send(:"#{extension}").remove.click
end

Then('the add an extension button should have the text {string}') do |button_text|
  expect(entering_requirements_page.optional_call_off_extensions.add_extension).to have_content(button_text)
end

Then('the add an extension button should be {string}') do |status|
  element_visivility_expectations(entering_requirements_page.optional_call_off_extensions.add_extension, status)
end

Then('the remove button for extension {int} should be {string}') do |extension, status|
  element_visivility_expectations(entering_requirements_page.optional_call_off_extensions.send(:"#{extension}").remove, status)
end

def element_visivility_expectations(element, status)
  case status
  when 'hidden'
    expect(element[:class]).to include('govuk-visually-hidden')
    expect(element[:tabindex]).to eq '-1'
  when 'visible'
    expect(element[:class]).not_to include('govuk-visually-hidden')
    expect(element[:tabindex]).to eq '0'
  end
end

Then('extension {int} should be {string}') do |extension, status|
  case status
  when 'hidden'
    expect(entering_requirements_page.optional_call_off_extensions.send(:"#{extension}")).to have_css('.govuk-visually-hidden')
  when 'visible'
    expect(entering_requirements_page.optional_call_off_extensions.send(:"#{extension}")).not_to have_css('.govuk-visually-hidden')
  end
end

Then('extension {int} should have the following error messages:') do |extension, error_messages|
  expect(entering_requirements_page.optional_call_off_extensions.send(:"#{extension}").error_messages.map(&:text)).to eq error_messages.raw.flatten
end

Then('my inital call off period length is {string}') do |initial_call_off_period_length|
  expect(entering_requirements_page.contract_period_summary.initial_call_off_period_length).to have_content(initial_call_off_period_length)
end

def format_date_period(start_date, end_date)
  "#{start_date.strftime('%e %B %Y')} to #{end_date.strftime('%e %B %Y')}"
end

Then('my inital call off period is correct given the contract start date') do
  @initial_call_off_end_date = @initial_call_off_period_start_date + @contract_period_years.years + @contract_period_months.months
  @initial_call_off_end_date -= 1.day if @initial_call_off_period_start_date.day == @initial_call_off_end_date.day
  initial_call_off_period_string = format_date_period(@initial_call_off_period_start_date, @initial_call_off_end_date)

  expect(entering_requirements_page.contract_period_summary.initial_call_off_period).to have_content(initial_call_off_period_string)
end

Then('mobilisation period length is {string}') do |mobilisation_period_length|
  expect(entering_requirements_page.contract_period_summary.mobilisation_period_length).to have_content(mobilisation_period_length)
end

Then('the mobilisation period is correct given the contract start date') do
  mobilisation_period = format_date_period(@initial_call_off_period_start_date - @mobilisation_period.weeks - 1.day, @initial_call_off_period_start_date - 1.day)

  expect(entering_requirements_page.contract_period_summary.mobilisation_period).to have_content(mobilisation_period)
end

Then('there are no optional call off extensions') do
  expect(entering_requirements_page.contract_period_summary.optional_call_off_extension).to have_content('None')
end

Then('the length of extension period {int} is {string}') do |extension, extension_length|
  expect(entering_requirements_page.contract_period_summary.send(:"extension_#{extension}_length")).to have_content(extension_length)
end

def extension_start_date(extension)
  additional_period = (1..(extension - 1)).sum { |index| @contract_extentsions[index] }

  @initial_call_off_end_date + additional_period + 1.day
end

def extension_end_date(extension)
  additional_period = (1..extension).sum { |index| @contract_extentsions[index] }

  @initial_call_off_end_date + additional_period
end

Then('extension period {int} is correct given the contract start date') do |extension|
  extension_period = format_date_period(extension_start_date(extension), extension_end_date(extension))

  expect(entering_requirements_page.contract_period_summary.send(:"extension_#{extension}_period")).to have_content(extension_period)
end

Then('I should see the following seleceted services in the summary:') do |services_summary|
  expect(page.all('table > tbody > tr > td').map(&:text)).to match_array services_summary.raw.flatten
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
  building_names.raw.flatten.each do |building_name|
    step "I find and select the building with the name '#{building_name}'"
  end
end

Then('I should see the following seleceted buildings in the summary:') do |buildings_summary|
  expect(page.all('table > tbody > tr > th').map(&:text)).to match_array buildings_summary.raw.flatten
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
  services.raw.flatten.each do |service|
    page.check(service)
  end
end

Then('I select the following service codes for the building:') do |services|
  services.raw.flatten.each do |service|
    page.check("facilities_management_procurement_building_service_codes_#{service.downcase.gsub('.', '')}")
  end
end

Then('the building should have the status {string}') do |status|
  expect(entering_requirements_page.building_status.text).to eq status
end

And('everything is completed') do
  expect(page.all('td > strong').all? { |status| status.text == 'completed' }).to be true
end
