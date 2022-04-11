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
