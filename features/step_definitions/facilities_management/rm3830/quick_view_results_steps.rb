Then('I open all sections') do
  step('I click on "Open all"') if @javascript
end

Then('I select {string}') do |item|
  page.check(item)
end

Then('I select the following items:') do |items|
  items.raw.flatten.each do |item|
    page.check(item)
  end
end

Then('I select all for {string}') do |item_group|
  page.find("[data-sectionname='#{item_group}']").find('input[name="section-checkbox_select_all"]').check
end

When('I deselect the following items:') do |items|
  items.raw.flatten.each do |item|
    page.uncheck(item)
  end
end

Then('I deselect all for {string}') do |item_group|
  page.find("[data-sectionname='#{item_group}']").find('input[name="section-checkbox_select_all"]').uncheck
end

When('I remove the following items from the basket:') do |items|
  items.raw.flatten.each do |item|
    quick_view_results_page.basket.selection(text: item).first.find(:xpath, '../div/span/a').click
  end
end

Then('the following items should appear in the basket:') do |items|
  expect(quick_view_results_page.basket.selection.map(&:text)).to match(items.raw.flatten)
end

Then('I select the service code {string}') do |service|
  page.check("#facilities_management_procurement_service_codes_#{service.upcase.gsub('.', '-')}")
end

Then('I select the following service codes:') do |services|
  services.raw.flatten.each do |service|
    page.check("facilities_management_procurement_service_codes_#{service.upcase.gsub('.', '-')}")
  end
end

Then('the basket should say {string}') do |basket_text|
  expect(quick_view_results_page.basket.selection_count).to have_content(basket_text)
end

Then('the remove all link should not be visible') do
  expect(quick_view_results_page.basket.remove_all).not_to be_visible
end

Then('the remove all link should be visible') do
  expect(quick_view_results_page.basket.remove_all).to be_visible
end

Then('select all {string} be checked for {string}') do |status, section|
  case status
  when 'should'
    expect(page.find("[data-sectionname='#{section}']").find('input[name="section-checkbox_select_all"]')).to be_checked
  when 'should not'
    expect(page.find("[data-sectionname='#{section}']").find('input[name="section-checkbox_select_all"]')).not_to be_checked
  end
end

Then('{int} {string} are slected') do |number, section|
  expect(quick_view_results_page.requirements_list.send(section.to_sym).summary).to have_content("#{number} selected")
end

Then('the following {string} are in the drop down:') do |section, items|
  quick_view_results_page.requirements_list.send(section.to_sym).summary.click

  expect(quick_view_results_page.requirements_list.send(section.to_sym).details.map(&:text)).to match(items.raw.flatten)
end

Then('the requirements {string} be visible') do |status|
  case status
  when 'should'
    expect(quick_view_results_page.requirements_list).to be_visible
  when 'should not'
    expect(quick_view_results_page.requirements_list).not_to be_visible
  end
end

Then('the contract name on the quick search results page is shown to be {string}') do |contract_name|
  expect(quick_view_results_page.quick_search_contract_name.text).to eq contract_name
end
