Then('I should be in the following sub-lots:') do |sub_lots|
  sub_lot_elements = quick_view_page.sub_lots
  expected_sub_lots = sub_lots.raw.flatten

  expect(sub_lot_elements.length).to eq(expected_sub_lots.length)

  sub_lot_elements.zip(expected_sub_lots).each do |sub_lot_element, expected_sublot|
    expect(sub_lot_element).to have_content("Sub-lot #{expected_sublot}")
  end
end

Then('there is a notification with the message {string}') do |notification_message|
  expect(quick_view_page.notification_banner.title).to have_content('Important')
  expect(quick_view_page.notification_banner.message).to have_content(notification_message)
end
