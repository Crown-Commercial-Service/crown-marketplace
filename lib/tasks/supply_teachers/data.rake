require 'aws-sdk-s3'
require 'fileutils'
namespace :st do
  task :clean do
    rm_f Dir[Rails.root.join('storage', 'supply_teachers', 'current_data', 'output', '*.tmp')]
    rm_f Dir[Rails.root.join('storage', 'supply_teachers', 'current_data', 'output', '*.json')]
    rm_f Dir[Rails.root.join('storage', 'supply_teachers', 'current_data', 'output', '*.out')]
    # s3 = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
    # folder = 'supply_teachers/current_data/output'
    # objects = s3.bucket(ENV['CCS_APP_API_DATA_BUCKET']).objects({prefix: folder})
    # objects.batch_delete!
  end

  task data: :environment do
    require Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'generate_branches.rb')
    require Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'generate_pricing.rb')
    require Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'generate_vendor_pricing.rb')
    require Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'generate_accreditation.rb')
    require Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'merge_json.rb')
    require Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'exclude_suppliers_without_accreditation.rb')
    require Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'add_vendor_contacts.rb')
    require Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'validate_and_geocode.rb')
    require Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'strip_line_numbers.rb')
    require Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'anonymize.rb')
    require Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'bootstrap_supplier_lookup.rb')

    # s3 = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])

    FileUtils.makedirs(Rails.root.join('storage', 'supply_teachers', 'current_data', 'output'))
    FileUtils.touch(Rails.root.join('storage', 'supply_teachers', 'current_data', 'output', 'errors.out'))

    run_script(generate_branches, get_output_file_path('supplier_branches.json'))
    run_script(generate_pricing, get_output_file_path('supplier_pricing.json'))
    run_script(generate_vendor_pricing, get_output_file_path('supplier_vendor_pricing.json'))
    run_script(generate_accreditation, get_output_file_path('supplier_accreditation.json'))
    run_script(
               merge_json(supplier_name_key: 'pricing supplier name',
                          destination_key: 'branches supplier name',
                          destination_file: get_output_file_path('data_branches_pricing.json'),
                          primary: get_output_file_path('supplier_branches.json'),
                          secondary: get_output_file_path('supplier_pricing.json')),
               get_output_file_path('data_branches_pricing.json'))
    run_script(
               merge_json(supplier_name_key: 'vendor supplier name',
                          destination_key: 'branches supplier name',
                          destination_file: get_output_file_path('data_branches_pricing_vendors.json'),
                          primary: get_output_file_path('data_branches_pricing.json'),
                          secondary: get_output_file_path('supplier_vendor_pricing.json')),
               get_output_file_path('data_branches_pricing_vendors.json'))
    run_script(
               merge_json(supplier_name_key: 'accreditation supplier name',
                          destination_key: 'branches supplier name',
                          destination_file: get_output_file_path('data_merged.json'),
                          primary: get_output_file_path('data_branches_pricing_vendors.json'),
                          secondary: get_output_file_path('supplier_accreditation.json')),
               get_output_file_path('data_merged.json'))
    run_script(exclude_suppliers_without_accreditation, get_output_file_path('data_only_accredited.json'))
    run_script(add_vendor_contacts, get_output_file_path('data_with_vendors.json'))
    run_script(validate_and_geocode, get_output_file_path('data_with_line_numbers.json'))
    run_script(strip_line_numbers, get_output_file_path('data.json'))
    run_script(anonymize, get_output_file_path('anonymous.json'))
    # run_script(s3, bootstrap_supplier_lookup, 'supply_teachers/current_data/output/supplier_lookup.json')

    # s3.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object('supply_teachers/current_data/output/errors.out').upload_file('./storage/supply_teachers/current_data/output/errors.out.tmp')
  end

  def run_script(script, file_path)
    File.open(get_output_file_path('errors.out'), 'a') do
      script.to_s
    end
    # s3.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(file_path).upload_file("./storage/#{file_path}.tmp")
  end

  def get_output_file_path(file_name)
    Rails.root.join('storage', 'supply_teachers', 'current_data', 'output', file_name)
  end

end