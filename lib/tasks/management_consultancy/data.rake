require 'aws-sdk-s3'
require 'fileutils'

namespace :mc do
  task :clean do
    rm_f Dir['./storage/supply_teachers/current_data/output/*.tmp']
    rm_f Dir['./storage/management_consultancy/current_data/output/*.json']
    rm_f Dir['./storage/management_consultancy/current_data/output/*.out']
  end

  task data: :environment do
    require './lib/tasks/management_consultancy/scripts/add_suppliers'
    require './lib/tasks/management_consultancy/scripts/add_service_offerings_per_supplier'
    require './lib/tasks/management_consultancy/scripts/add_region_availability_per_lot_per_supplier'
    require './lib/tasks/management_consultancy/scripts/add_rate_cards_to_suppliers'

    input = File.dirname('./storage/management_consultancy/current_data/input')
    FileUtils.mkdir_p(input) unless File.directory?(input)
    output = File.dirname('./storage/management_consultancy/current_data/output')
    FileUtils.mkdir_p(output) unless File.directory?(output)

    def run_script(s3, script, file_path)
      './storage/management_consultancy/current_data/output/errors.out.tmp' << script.to_s
      s3.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(file_path).upload_file("./storage/#{file_path}.tmp")
    end

    if Rails.env.production?
      s3 = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
      run_script(s3, add_suppliers, './storage/management_consultancy/current_data/output/suppliers.json')
      run_script(s3, add_service_offerings_per_supplier, './storage/management_consultancy/current_data/output/suppliers_with_service_offerings.json')
      run_script(s3, add_region_availability_per_lot_per_supplier, './storage/management_consultancy/current_data/output/suppliers_with_service_offerings_and_regional_availability.json')
      run_script(s3, add_rate_cards_to_suppliers, './storage/management_consultancy/current_data/output/data.json')
      s3.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object('management_consultancy/current_data/output/errors.out').upload_file('./storage/management_consultancy/current_data/output/errors.out.tmp')
    else
      touch './storage/management_consultancy/current_data/output/errors.out'
      add_suppliers
      add_service_offerings_per_supplier
      add_region_availability_per_lot_per_supplier
      add_rate_cards_to_suppliers
    end
  end
end
