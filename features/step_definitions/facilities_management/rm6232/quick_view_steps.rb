Then('I enter {string} for the annual contract value') do |value|
  quick_view_rm6232_page.annual_contract_value.set(value)
end

Then('I should be in sub-lot {string}') do |sub_lot|
  expect(quick_view_rm6232_page.sub_lot).to have_content("Sub-lot #{sub_lot}")
end

Then('I should see the following {string} in the selection summary:') do |option, selection_summary_table|
  case option
  when 'services', 'regions'
    quick_view_rm6232_page.selection_summary.send(option.to_sym).selection.zip(selection_summary_table.raw.flatten).each do |element, expected_value|
      expect(element).to have_content(expected_value)
    end
  when 'annual contract value'
    expect(quick_view_rm6232_page.selection_summary.send(option.to_sym).selection).to have_content(selection_summary_table.raw.flatten.first)
  end
end

Given('I change the {string} from the selection summary') do |option|
  quick_view_rm6232_page.selection_summary.send(option.to_sym).change.click
end
