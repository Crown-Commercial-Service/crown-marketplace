And('I select {string} for estimated annual cost known') do |option|
  case option
  when 'Yes'
    entering_requirements_page.estimated_cost_known_yes.choose
  when 'No'
    entering_requirements_page.estimated_cost_known_no.choose
  end
end

And('I enter {string} for estimated annual cost') do |estimated_annual_cost|
  entering_requirements_page.estimated_cost_known.set(estimated_annual_cost)
end

Then('I select the service code {string} for the building') do |service|
  entering_requirements_page.check("facilities_management_rm3830_procurement_building_service_codes_#{service.downcase.gsub('.', '_')}")
end

Then('I select the following service codes for the building:') do |services|
  services.raw.flatten.each do |service|
    entering_requirements_page.check("facilities_management_rm3830_procurement_building_service_codes_#{service.downcase.gsub('.', '_')}")
  end
end

Then('the service requirements status for {string} is {string}') do |building_name, status|
  expect(building_status(building_name)).to have_content(status.downcase)
end
