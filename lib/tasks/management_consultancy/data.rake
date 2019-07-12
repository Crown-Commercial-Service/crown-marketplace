require 'aws-sdk-s3'
require 'fileutils'

namespace :mc do
  task :clean do
    if Rails.env.development?
      rm_f Dir['storage/management_consultancy/current_data/output/*.tmp']
      rm_f Dir['storage/management_consultancy/current_data/output/*.json']
      rm_f Dir['storage/management_consultancy/current_data/output/*.out']
    else
      object = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
      object.bucket(ENV['CCS_APP_API_DATA_BUCKET']).objects({prefix: 'management_consultancy/current_data/output/'}).batch_delete!
    end
  end

  task data: :environment do
    require Rails.root.join('lib', 'tasks', 'management_consultancy', 'scripts', 'add_suppliers')
    require Rails.root.join('lib', 'tasks', 'management_consultancy', 'scripts', 'add_service_offerings_per_supplier')
    require Rails.root.join('lib', 'tasks', 'management_consultancy', 'scripts', 'add_region_availability_per_lot_per_supplier')
    require Rails.root.join('lib', 'tasks', 'management_consultancy', 'scripts', 'add_rate_cards_to_suppliers')

    FileUtils.makedirs(Rails.root.join('storage', 'management_consultancy', 'current_data', 'output'))
    FileUtils.touch(Rails.root.join('storage', 'management_consultancy', 'current_data', 'output', 'errors.out'))

    run_script add_suppliers
    run_script add_service_offerings_per_supplier
    run_script add_region_availability_per_lot_per_supplier
    run_script add_rate_cards_to_suppliers

    upload_data_and_errors_to_s3 unless Rails.env.development?
  end

  def run_script(script)
    File.open(get_mc_output_file_path('errors.out'), 'a') do
      script.to_s
    end
  end

  def get_mc_output_file_path(file_name)
    Rails.root.join('storage', 'management_consultancy', 'current_data', 'output', file_name)
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

  def write_output_file(file_name, json_output)
    file_path = get_mc_output_file_path(file_name)
    File.open(file_path, 'w') do |f|
      f.puts JSON.pretty_generate(json_output)
    end
  end

  def upload_data_and_errors_to_s3
    object = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
    object.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(s3_path_folder(get_mc_output_file_path('data.json').to_s)).upload_file(get_mc_output_file_path('data.json'), {acl:'public-read'})
    object.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(s3_path_folder(get_mc_output_file_path('errors.out').to_s)).upload_file(get_mc_output_file_path('errors.out'), {acl:'public-read'}) unless File.zero?(get_mc_output_file_path('errors.out'))
  end
end
