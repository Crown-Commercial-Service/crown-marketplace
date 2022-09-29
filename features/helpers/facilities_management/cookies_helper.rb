def update_banner_cookie(status)
  page.driver.browser.manage.add_cookie(name: 'crown_marketplace_cookie_options_v1', value: {
    settings_viewed: status,
    google_analytics_enabled: false,
    glassbox_enabled: false
  }.to_json)
end
