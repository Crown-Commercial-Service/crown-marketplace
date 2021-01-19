Capybara.configure do |config|
  config.default_driver = (ENV['DRIVER'].to_sym if ENV['DRIVER'])  || :chrome_headless
  config.default_max_wait_time = 30
  config.match = :prefer_exact
  config.ignore_hidden_elements = false
  config.visible_text_only = true
end


Capybara.register_driver :chrome do |app|
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.timeout = 120
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: { w3c: false }
  )

  Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      desired_capabilities: capabilities,
      http_client: client
  )
end

Capybara.register_driver :chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new(args: %w[no-sandbox headless disable-gpu])

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara::Screenshot.register_driver(:chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end

Capybara::Screenshot.register_driver(:chrome_headless) do |driver, path|
  driver.browser.save_screenshot(path)
end

Capybara::Screenshot.register_filename_prefix_formatter(:cucumber) do |scenario|
  case scenario
  when Cucumber::RunningTestCase::Scenario
    @scenario_name = scenario.name
  when Cucumber::RunningTestCase::ScenarioOutlineExample
    @scenario_name = scenario.scenario_outline.name
  end
  "screenshot_cucumber_#{@scenario_name.tr(' ', '-').gsub(%r{/^.*\/cucumber\//}, '')}"
end

def screenshot_path
    "tmp/cucumber_screenshots/"
end

Capybara.save_path = screenshot_path
Capybara.javascript_driver = Capybara.default_driver
Capybara.current_driver = Capybara.default_driver
Capybara.app_host = ENV['HOST'] if ENV['HOST']
Capybara.default_max_wait_time = 30
