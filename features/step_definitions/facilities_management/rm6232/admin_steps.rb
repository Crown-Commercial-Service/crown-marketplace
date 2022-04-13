Then('I should see all the suppliers') do
  expect(admin_rm6232_page.suppliers.length).to eq 50
end

Then('I enter {string} for the supplier search') do |supplier_name|
  admin_rm6232_page.supplier_search_input.fill_in with: "#{supplier_name}\n"
end

Then('I should see the following suppliers on the page:') do |supplier_names|
  expect(admin_rm6232_page.suppliers.length).to eq(supplier_names.raw.flatten.length)

  admin_rm6232_page.suppliers.map(&:supplier_name).zip(supplier_names.raw.flatten).each do |element, value|
    expect(element).to have_content(value)
  end
end

Then('I click on {string} for {string}') do |text, supplier_name|
  admin_rm6232_page.suppliers.find { |element| element.supplier_name.text == supplier_name }.send(text).click
end

Then('the supplier name shown is {string}') do |supplier_name|
  expect(admin_rm6232_page.supplier_name_sub_title).to have_content(supplier_name)
end

Then('they have services and regions for the following lots:') do |lots|
  admin_rm6232_page.lot_data_tables.map(&:title).zip(lots.raw.flatten).each do |element, value|
    expect(element).to have_content(value)
  end
end

Then('I change the {string} for lot {string}') do |lot_data_type, lot_code|
  admin_rm6232_page.lot_data.send("lot_#{lot_code}").send(lot_data_type).change_link.click
end

Then('I deselect all checkboxes') do
  admin_rm6232_page.all('input[type="checkbox"][checked="checked"]').each(&:uncheck)
end

Then('I should see the following {string} selected for lot {string}:') do |lot_data_type, lot_code, items|
  expected_names = items.raw.flatten
  actual_names = admin_rm6232_page.lot_data.send("lot_#{lot_code}").send(lot_data_type).names.map(&:text)

  expect(actual_names).to eq expected_names
end
