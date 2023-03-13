Then('I enter {string} for the email domain') do |email_domain|
  allow_list_page.add_email_domain_form.email_domain.set(email_domain)
end

Then('the following email domains are in the list:') do |email_domains_table|
  expected_email_domains = email_domains_table.raw.flatten
  actual_email_domains = allow_list_page.email_domains_table.rows.map(&:email_domain)

  expect(expected_email_domains.length).to eq actual_email_domains.length

  actual_email_domains.zip(expected_email_domains).each do |element, value|
    expect(element).to have_content(value)
  end
end

Then('I click on remove for {string}') do |email_domain|
  allow_list_page.email_domains_table.rows.find { |row| row.email_domain.text == email_domain }.remove_link.click
end

Then('the email domian {string} has been succesffuly added') do |email_domain|
  expect(allow_list_page.notification_banner.heading).to have_content('Email domain added')
  expect(allow_list_page.notification_banner.message).to have_content("'#{email_domain}' was added to the allow list")
end

Then('the email domian {string} has been succesffuly removed') do |email_domain|
  expect(allow_list_page.notification_banner.heading).to have_content('Email domain removed')
  expect(allow_list_page.notification_banner.message).to have_content("'#{email_domain}' was removed from the allow list")
end

Then('I enter {string} into the email domain search') do |email_domain|
  allow_list_page.email_domain_search.input.fill_in with: email_domain
  allow_list_page.email_domain_search.button.click
end

Then('I cannot add an email domain') do
  expect(allow_list_page).not_to have_link(href: '/crown-marketplace/allow-list/new')
end

Then('I cannot remove an email domain') do
  expect(allow_list_page.email_domains_table.rows.map { |row| row.all('a') }.all?(&:empty?)).to be true
end
