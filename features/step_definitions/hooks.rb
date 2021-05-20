Before('@javascript') do
  @javascript = true
end

Before('@add_address') do
  stub_address_region_finder
end

Before('not @javascript') do
  page.driver.browser.set_cookie('crown_marketplace_cookie_settings_viewed=true')
end
