def update_banner_cookie(status)
  page.driver.browser.manage.add_cookie(name: 'crown_marketplace_cookie_settings_viewed', value: status.to_s)
end
