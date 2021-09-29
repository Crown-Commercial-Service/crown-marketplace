Rails.autoloaders.each do |autoloader|
  autoloader.inflector.inflect(
    'gov_uk_helper' => 'GovUKHelper',
    'update_fc_data' => 'UpdateFCData'
  )
end
