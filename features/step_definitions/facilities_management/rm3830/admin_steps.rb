Given('I go to the buyer dashboard') do
  visit facilities_management_rm3830_path
end

Given('I sign out and sign in the admin user') do
  step "I click on 'Sign out'"
  visit facilities_management_rm3830_admin_new_user_session_path
  fill_in 'email', with: @user.email
  fill_in 'password', with: 'ValidPassword'
  click_on 'Sign in'
  expect(page.find('h1')).to have_content('RM3830 administration dashboard')
end

Given('select {string} for sublot {string} for {string}') do |option, sublot, supplier|
  link_text = if option == 'Services' && sublot == '1a'
                'Services, prices and variances'
              else
                option
              end

  supplier_section = admin_page.find('h2', text: supplier).find(:xpath, '../..')
  sublot_section = supplier_section.find('span', text: "Sub-lot #{sublot}").find(:xpath, '..')
  sublot_section.click_on(link_text)
end

Then('I go to a quick view with the following services and regions:') do |services_and_regions|
  service_codes = services_and_regions.transpose.raw[0].compact_blank
  region_codes = services_and_regions.transpose.raw[1].compact_blank

  visit new_facilities_management_rm3830_procurement_path(journey: 'facilities-management', service_codes: service_codes, region_codes: region_codes)
  expect(page.find('h1')).to have_content('Quick view results')
end

Then('{string} is not a supplier in Sub-lot {string}') do |supplier, sublot|
  supplier_list = quick_view_page.results_container.send(sublot).suppliers.map(&:text)

  expect(supplier_list).not_to include supplier
end

Then('{string} is a supplier in Sub-lot {string}') do |supplier, sublot|
  supplier_list = quick_view_page.results_container.send(sublot).suppliers.map(&:text)

  expect(supplier_list).to include supplier
end

Given('I enter the user email into the user email field') do
  admin_page.supplier_detail_form.send(:'User email').set(@user.email)
end

Given('other user accounts exist') do
  create(:user, :with_detail, confirmed_at: Time.zone.now, roles: %i[buyer fm_access], email: 'buyer@test.com')
  supplier_user = create(:user, :with_detail, confirmed_at: Time.zone.now, roles: %i[fm_access supplier], email: 'othersupplier@test.com')
  create(:facilities_management_rm3830_supplier_detail, user: supplier_user)
end

Given('I enter {string} into the Direct award discount filed for {string}') do |value, service|
  admin_page.find(:xpath, "//label[text()='#{service}']/../../../../td[1]/input").set(value)
end

Given('I enter {string} into the variance for {string}') do |value, variance|
  admin_page.find(:xpath, "//label[text()='#{variance}']/../../td[1]/input").set(value)
end

Given('I enter {string} into the price for {string} under {string}') do |price, service, building_type|
  index = BUILDING_TYPES.index(building_type) + 2
  admin_page.find(:xpath, "//label[text()='#{service}']/../../../../td[#{index}]/input").set(price)
end

BUILDING_TYPES = ['General office - Customer Facing', 'General office - Non Customer Facing', 'Call Centre Operations', 'Warehouses', 'Restaurant and Catering Facilities', 'Pre-School', 'Primary School', 'Secondary Schools', 'Special Schools', 'Universities and Colleges', 'Community - Doctors, Dentist, Health Clinic', 'Nursing and Care Homes'].freeze

Given('I enter the servie rate of {string} for {string}') do |value, field|
  fill_in field, with: value
end

Given('I enter the variance of {string} for {string}') do |value, field|
  fill_in field, with: value
end

STANDARD_COLUMN = { 'A' => 1, 'B' => 2, 'C' => 3 }.freeze

Given('I enter the servie rate of {string} for {string} standard {string}') do |value, field, standard|
  service_standard = standard == '' ? 'normal price' : "standard #{standard}"

  admin_page.find("input[aria-label='#{field} #{service_standard}']").set(value)
end

Then('the following services should have the following rates:') do |services_and_rates|
  services_and_rates.raw.each do |service_and_rate|
    expect(admin_page.find_field(service_and_rate[0]).value).to eq service_and_rate[1]
  end
end

Then('the following services should have the following rates for their standard:') do |services_and_rates|
  services_and_rates.raw.each do |service_and_rate|
    service_standard = service_and_rate[2] == '' ? 'normal price' : "standard #{service_and_rate[2]}"

    expect(admin_page.find("input[aria-label='#{service_and_rate[0]} #{service_standard}']").value).to eq service_and_rate[1]
  end
end

Then('I enter the service requirements for {string} in the assessed value procurement') do |building_name|
  step "I click on 'Service requirements'"
  step "I click on '#{building_name}'"
  step "I choose to answer the service volume question for 'Routine cleaning'"
  step "I am on the page with secondary heading 'Routine cleaning'"
  step "I enter '34' for the service volume"
  step "I click on 'Save and return'"
  step "I choose to answer the service volume question for 'Reception service'"
  step "I am on the page with secondary heading 'Reception service'"
  step "I enter '6240' for the number of hours per year"
  step 'I enter the following for the detail of requirement:', table(%(
    | This is some details of requirement |
  ))
  step "I click on 'Save and return'"
  step "I choose to answer the service volume question for 'General waste'"
  step "I am on the page with secondary heading 'General waste'"
  step "I enter '130' for the service volume"
  step "I click on 'Save and return'"
  step "I choose to answer the service standard question for 'Mechanical and electrical engineering maintenance'"
  step "I am on the page with secondary heading 'Mechanical and electrical engineering maintenance'"
  step "I select Standard 'A'"
  step "I click on 'Save and return'"
  step "I choose to answer the service standard question for 'Routine cleaning'"
  step "I am on the page with secondary heading 'Routine cleaning'"
  step "I select Standard 'A'"
  step "I click on 'Save and return'"
  step "I click on 'Return to service requirements summary'"
  step "I click on 'Return to requirements'"
end
