Before('@javascript') do
  @javascript = true
end

Before('@add_address') do
  stub_address_region_finder
end

Before('@allow_list') do
  stub_allow_list
end

After('@allow_list') do
  close_allow_list
end

Before('not @javascript') do
  page.driver.browser.set_cookie('crown_marketplace_cookie_settings_viewed=true')
end

Before('@contract_emails') do
  stub_contract_emails
end
