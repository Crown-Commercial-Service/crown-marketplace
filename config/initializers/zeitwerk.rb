Rails.autoloaders.each do |autoloader|
  autoloader.inflector.inflect(
    'fm_calculator' => 'FMCalculator',
    'gov_uk_helper' => 'GovUKHelper',
    'generate_fm_admin_report_job' => 'GenerateFMAdminReportJob',
    'update_fc_data' => 'UpdateFCData'
  )
end
