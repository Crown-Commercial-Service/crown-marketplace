Then('I select all for {string}') do |item_group|
  page.find("[data-sectionname='#{item_group}']").find('input[name="section-checkbox_select_all"]').check
end

When('I deselect the following items:') do |items|
  items.raw.flatten.each do |item|
    page.uncheck(item)
  end
end

When('I remove the following items from the basket:') do |items|
  items.raw.flatten.each do |item|
    quick_view_page.basket.selection(text: item).first.find(:xpath, '../div/span/a').click
  end
end

Then('the following items should appear in the basket:') do |items|
  expect(quick_view_page.basket.selection.map(&:text)).to match(items.raw.flatten)
end

Then('the basket should say {string}') do |basket_text|
  expect(quick_view_page.basket.selection_count).to have_content(basket_text)
end

Then('the remove all link should not be visible') do
  expect(quick_view_page.basket.remove_all).not_to be_visible
end

Then('the remove all link should be visible') do
  expect(quick_view_page.basket.remove_all).to be_visible
end

Then('select all {string} be checked for {string}') do |status, section|
  case status
  when 'should'
    expect(page.find("[data-sectionname='#{section}']").find('input[name="section-checkbox_select_all"]')).to be_checked
  when 'should not'
    expect(page.find("[data-sectionname='#{section}']").find('input[name="section-checkbox_select_all"]')).not_to be_checked
  end
end
