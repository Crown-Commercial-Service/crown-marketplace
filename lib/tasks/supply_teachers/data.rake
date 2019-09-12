require 'fileutils'

namespace :st do
  task :clean do
    if Rails.env.development?
      rm_f Dir[Rails.root.join('storage', 'supply_teachers', 'current_data', 'output', '*.tmp')]
      rm_f Dir[Rails.root.join('storage', 'supply_teachers', 'current_data', 'output', '*.json')]
      rm_f Dir[Rails.root.join('storage', 'supply_teachers', 'current_data', 'output', '*.out')]
    else
      object = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
      object.bucket(ENV['CCS_APP_API_DATA_BUCKET']).objects({prefix: 'supply_teachers/current_data/output/'}).batch_delete!
    end
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

    FileUtils.makedirs(Rails.root.join('storage', 'supply_teachers', 'current_data', 'output'))
    FileUtils.touch(Rails.root.join('storage', 'supply_teachers', 'current_data', 'output', 'errors.out'))

    run_script(generate_branches)
    run_script(generate_pricing)
    run_script(generate_vendor_pricing)
    run_script(generate_accreditation)
    run_script(merge_json(supplier_name_key: 'pricing supplier name',
                          destination_key: 'branches supplier name',
                          destination_file: get_output_file_path('data_branches_pricing.json'),
                          primary: get_output_file_path('supplier_branches.json'),
                          secondary: get_output_file_path('supplier_pricing.json')))
    run_script(merge_json(supplier_name_key: 'vendor supplier name',
                          destination_key: 'branches supplier name',
                          destination_file: get_output_file_path('data_branches_pricing_vendors.json'),
                          primary: get_output_file_path('data_branches_pricing.json'),
                          secondary: get_output_file_path('supplier_vendor_pricing.json')))
    run_script(merge_json(supplier_name_key: 'accreditation supplier name',
                          destination_key: 'branches supplier name',
                          destination_file: get_output_file_path('data_merged.json'),
                          primary: get_output_file_path('data_branches_pricing_vendors.json'),
                          secondary: get_output_file_path('supplier_accreditation.json')))
    run_script(exclude_suppliers_without_accreditation)
    run_script(add_vendor_contacts)
    run_script(validate_and_geocode)
    run_script(strip_line_numbers)
    # we are using test data on non-production environment so this is not needed anymore
    # run_script(anonymize)

    upload_data_and_errors_to_s3 unless Rails.env.development?
  end

  def run_script(script)
    File.open(get_output_file_path('errors.out'), 'a') do
      script.to_s
    end
  end

  def get_output_file_path(file_name)
    Rails.root.join('storage', 'supply_teachers', 'current_data', 'output', file_name)
  end

  def file_path(path)
    return path if Rails.env.development?
    s3_path(path.to_s)
  end

  def s3_path(path)
    "https://s3-#{ENV['COGNITO_AWS_REGION']}.amazonaws.com/#{ENV['CCS_APP_API_DATA_BUCKET']}/#{s3_path_folder(path)}"
  end

  def s3_path_folder(path)
    path.slice((path.index('storage/') + 8)..path.length)
  end

  def upload_data_and_errors_to_s3
    object = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
    object.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(s3_path_folder(get_output_file_path('data.json').to_s)).upload_file(get_output_file_path('data.json'), {acl:'private'})
    object.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(s3_path_folder(get_output_file_path('errors.out').to_s)).upload_file(get_output_file_path('errors.out'), {acl:'private'}) unless File.zero?(get_output_file_path('errors.out'))
  end

end