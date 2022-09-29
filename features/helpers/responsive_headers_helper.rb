def resize_window_to_mobile
  resize_window_by([640, 480])
end

def resize_window_to_pc
  Capybara.page.driver.browser.manage.window.maximize if Capybara.current_session.driver.browser.respond_to? 'manage'
end

def resize_window_by(size)
  Capybara.current_session.driver.browser.manage.window.resize_to(size[0], size[1]) if Capybara.current_session.driver.browser.respond_to? 'manage'
end
