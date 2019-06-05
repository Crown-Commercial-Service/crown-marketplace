require 'aws-sdk-s3'
require 'fileutils'
namespace :st do
  task :clean do
    rm_f Dir['./storage/supply_teachers/current_data/output/*.tmp']
    rm_f Dir['./storage/supply_teachers/current_data/output/*.json']
    rm_f Dir['./storage/supply_teachers/current_data/output/*.out']
    s3 = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
    folder = 'supply_teachers/current_data/output'
    objects = s3.bucket(ENV['CCS_APP_API_DATA_BUCKET']).objects({prefix: folder})
    objects.batch_delete!
  end

  task data: :environment do
    require './lib/tasks/supply_teachers/scripts/generate_branches.rb'
    require './lib/tasks/supply_teachers/scripts/generate_pricing.rb'
    require './lib/tasks/supply_teachers/scripts/generate_vendor_pricing.rb'
    require './lib/tasks/supply_teachers/scripts/generate_accreditation.rb'
    require './lib/tasks/supply_teachers/scripts/merge_json.rb'
    require './lib/tasks/supply_teachers/scripts/exclude_suppliers_without_accreditation.rb'
    require './lib/tasks/supply_teachers/scripts/add_vendor_contacts.rb'
    require './lib/tasks/supply_teachers/scripts/validate_and_geocode.rb'
    require './lib/tasks/supply_teachers/scripts/strip_line_numbers.rb'
    require './lib/tasks/supply_teachers/scripts/anonymize.rb'
    require './lib/tasks/supply_teachers/scripts/bootstrap_supplier_lookup.rb'

    s3 = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])

    input = File.dirname('./storage/supply_teachers/current_data/input/')
    unless File.directory?(input)
      FileUtils.mkdir_p(input)
    end
    output = File.dirname('./storage/supply_teachers/current_data/output/')
    unless File.directory?(output)
      FileUtils.mkdir_p(output)
    end

    FileUtils.touch("./storage/supply_teachers/current_data/output/errors.out.tmp")

    run_script(s3, generate_branches, 'supply_teachers/current_data/output/supplier_branches.json')
    run_script(s3, generate_pricing, 'supply_teachers/current_data/output/supplier_pricing.json')
    run_script(s3, generate_vendor_pricing, 'supply_teachers/current_data/output/supplier_vendor_pricing.json')
    run_script(s3, generate_accreditation, 'supply_teachers/current_data/output/supplier_accreditation.json')
    run_script(s3,
               merge_json(supplier_name_key: 'pricing supplier name',
                          destination_key: 'branches supplier name',
                          destination_file: './storage/supply_teachers/current_data/output/data_branches_pricing.json.tmp',
                          primary: './storage/supply_teachers/current_data/output/supplier_branches.json.tmp',
                          secondary: './storage/supply_teachers/current_data/output/supplier_pricing.json.tmp'),
             'supply_teachers/current_data/output/data_branches_pricing.json')
    run_script(s3,
               merge_json(supplier_name_key: 'vendor supplier name',
                          destination_key: 'branches supplier name',
                          destination_file: './storage/supply_teachers/current_data/output/data_branches_pricing_vendors.json.tmp',
                          primary: './storage/supply_teachers/current_data/output/data_branches_pricing.json.tmp',
                          secondary: './storage/supply_teachers/current_data/output/supplier_vendor_pricing.json.tmp'),
             'supply_teachers/current_data/output/data_branches_pricing_vendors.json')
    run_script(s3,
               merge_json(supplier_name_key: 'accreditation supplier name',
                          destination_key: 'branches supplier name',
                          destination_file: './storage/supply_teachers/current_data/output/data_merged.json.tmp',
                          primary: './storage/supply_teachers/current_data/output/data_branches_pricing_vendors.json.tmp',
                          secondary: './storage/supply_teachers/current_data/output/supplier_accreditation.json.tmp'),
             'supply_teachers/current_data/output/data_merged.json')
    run_script(s3, exclude_suppliers_without_accreditation, 'supply_teachers/current_data/output/data_only_accredited.json')
    run_script(s3, add_vendor_contacts, 'supply_teachers/current_data/output/data_with_vendors.json')
    run_script(s3, validate_and_geocode, 'supply_teachers/current_data/output/data_with_line_numbers.json')
    run_script(s3, strip_line_numbers, 'supply_teachers/current_data/output/data.json')
    run_script(s3, anonymize, 'supply_teachers/current_data/output/anonymous.json')
    # run_script(s3, bootstrap_supplier_lookup, 'supply_teachers/current_data/output/supplier_lookup.json')

    s3.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object('supply_teachers/current_data/output/errors.out').upload_file('./storage/supply_teachers/current_data/output/errors.out.tmp')
  end

  def run_script(s3, script, file_path)
    './storage/supply_teachers/current_data/output/errors.out.tmp' << script.to_s
    s3.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(file_path).upload_file("./storage/#{file_path}.tmp")
  end

end