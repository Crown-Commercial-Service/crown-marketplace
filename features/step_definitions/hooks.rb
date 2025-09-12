# We need to do this because in Rails 7.2 the data is not preserved between the test server and the capybara server.
# This means we are using the truncation strategy so must reload the data between tests
Before('@javascript') do
  DatabaseCleaner.strategy = :truncation, { except: %w[spatial_ref_sys facilities_management_regions facilities_management_rm3830_static_data facilities_management_rm3830_rates facilities_management_rm3830_units_of_measurements facilities_management_rm6232_work_packages facilities_management_rm6232_services facilities_management_security_types nuts_regions os_address os_address_admin_uploads postcodes_nuts_regions] }
end

Before('not @javascript') do
  DatabaseCleaner.strategy = :transaction
end

# Ensure DatabaseCleaner starts and cleans up properly
Before do
  DatabaseCleaner.start
end

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
  page.driver.browser.set_cookie('cookie_preferences_cmp=%7B%22settings_viewed%22%3Atrue%2C%22usage%22%3Afalse%2C%22glassbox%22%3Afalse%7D')
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

Before do
  if @framework == 'RM3830' && FacilitiesManagement::RM3830::SupplierDetail.none?
    Rake::Task['db:rm3830:fm_supplier_data'].reenable
    Rake::Task['db:rm3830:add_supplier_rate_cards'].reenable

    Rake::Task['db:rm3830:fm_supplier_data'].invoke
    Rake::Task['db:rm3830:add_supplier_rate_cards'].invoke
  elsif @framework == 'RM6232' && FacilitiesManagement::RM6232::Supplier.none?
    Rake::Task['db:rm6232:import_suppliers'].reenable

    Rake::Task['db:rm6232:import_suppliers'].invoke
  end
end

After do
  DatabaseCleaner.clean
  if Framework.none?
    Rake::Task['db:frameworks'].reenable
    Rake::Task['db:make_rm6232_live'].reenable

    Rake::Task['db:frameworks'].invoke
    Rake::Task['db:make_rm6232_live'].invoke

    if @framework == 'RM3830'
      Rake::Task['db:rm3830:fm_supplier_data'].reenable
      Rake::Task['db:rm3830:add_supplier_rate_cards'].reenable

      Rake::Task['db:rm3830:fm_supplier_data'].invoke
      Rake::Task['db:rm3830:add_supplier_rate_cards'].invoke
    elsif @framework == 'RM6232'
      Rake::Task['db:rm6232:import_suppliers'].reenable

      Rake::Task['db:rm6232:import_suppliers'].invoke
    end
  end
end
