Before('@javascript') do
  @javascript = true
end

Before('@add_address') do
  stub_address_region_finder
end
