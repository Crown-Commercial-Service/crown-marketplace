Then('I enter {string} for the annual contract cost') do |value|
  quick_view_page.annual_contract_value.set(value)
end

Then('I should be in sub-lot {string}') do |sub_lot|
  expect(quick_view_page.sub_lot).to have_content("Sub-lot #{sub_lot}")
end

Then('I should see the following {string} in the selection summary:') do |option, selection_summary_table|
  case option
  when 'services', 'regions'
    quick_view_page.selection_summary.send(option.to_sym).selection.zip(selection_summary_table.raw.flatten).each do |element, expected_value|
      expect(element).to have_content(expected_value)
    end
  when 'annual contract cost'
    expect(quick_view_page.selection_summary.send(option.to_sym).selection).to have_content(selection_summary_table.raw.flatten.first)
  end
end

Given('I change the {string} from the selection summary') do |option|
  quick_view_page.selection_summary.send(option.to_sym).change.click
end

Given('I click on the service specification for {string}') do |service_name|
  quick_view_page.find('label', text: service_name).find(:xpath, '../div/a').click
end

Then('the page sub title is {string}') do |sub_title|
  expect(quick_view_page.service_specification.sub_title).to have_content(sub_title)
end

Then('The service name and code is {string}') do |service_name_and_code|
  expect(quick_view_page.service_specification.service_name_and_code).to have_content(service_name_and_code)
end

Then('there {string} generic requirements') do |option|
  case option
  when 'are'
    expect(quick_view_page).to have_css('details.govuk-details')
  when 'are not'
    expect(quick_view_page).not_to have_css('details.govuk-details')
  end
end
