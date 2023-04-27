Before do |scenario|
  %w[rm3830 rm6232].each do |framework|
    if scenario.location.file.include? framework
      @framework = framework.upcase
      break
    end
  end
end

Before('@javascript') do
  @javascript = true
end

Before('@allow_list') do
  stub_allow_list
end

After('@allow_list') do
  close_allow_list
end

Before('not @javascript') do
  page.driver.browser.set_cookie('cookie_preferences=%7B%22settings_viewed%22%3Atrue%2C%22usage%22%3Afalse%2C%22glassbox%22%3Afalse%7D')
end

Before('@management_report') do
  stub_management_report
end

Before('@mobile') do
  resize_window_to_mobile
end

After('@mobile') do
  resize_window_to_pc
end
