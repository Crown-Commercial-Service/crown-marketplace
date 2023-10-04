def update_banner_cookie(status)
  page.driver.browser.manage.add_cookie(name: 'cookie_preferences', value: {
    settings_viewed: status,
    usage: false,
    glassbox: false
  }.to_json)
end
