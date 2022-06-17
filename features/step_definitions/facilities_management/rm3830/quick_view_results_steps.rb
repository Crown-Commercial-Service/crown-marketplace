Then('I deselect all for {string}') do |item_group|
  page.find("[data-sectionname='#{item_group}']").find('input[name="section-checkbox_select_all"]').uncheck
end

Then('I select the service code {string}') do |service|
  page.check("#facilities_management_rm3830_procurement_service_codes_#{service.upcase.gsub('.', '-')}")
end

Then('I select the following service codes:') do |services|
  services.raw.flatten.each do |service|
    page.check("facilities_management_rm3830_procurement_service_codes_#{service.upcase.gsub('.', '-')}")
  end
end

Then('{int} {string} are slected') do |number, section|
  expect(quick_view_page.requirements_list.send(section.to_sym).summary).to have_content("#{number} selected")
end

Then('the following {string} are in the drop down:') do |section, items|
  quick_view_page.requirements_list.send(section.to_sym).summary.click

  expect(quick_view_page.requirements_list.send(section.to_sym).details.map(&:text)).to match(items.raw.flatten)
end

Then('the requirements {string} be visible') do |status|
  case status
  when 'should'
    expect(quick_view_page.requirements_list).to be_visible
  when 'should not'
    expect(quick_view_page.requirements_list).not_to be_visible
  end
end

Then('the contract name on the quick search results page is shown to be {string}') do |contract_name|
  expect(quick_view_page.quick_search_contract_name.text).to eq contract_name
end
