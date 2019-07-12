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
  end

  def run_script(script)
    File.open(get_mc_output_file_path('errors.out'), 'a') do
      script.to_s
    end
  end

  def get_mc_input_file_path(file_path)
    return file_path if Rails.env.development?
    s3_path(file_path)
  end

  def get_mc_output_file_path(file_name)
    file_path = "storage/management_consultancy/current_data/output/#{file_name}"
    return file_path if Rails.env.development?
    s3_path(file_path)
  end

  def s3_path(path)
    "https://s3-#{ENV['COGNITO_AWS_REGION']}.amazonaws.com/#{ENV['CCS_APP_API_DATA_BUCKET']}/#{s3_path_folder(path)}"
  end

  def s3_path_folder(path)
    path.slice((path.index('storage/') + 8)..path.length)
  end

  def write_output_file(file_name, json_output)
    file_path = "storage/management_consultancy/current_data/output/#{file_name}"
    File.open(file_path, 'w') do |f|
      f.puts JSON.pretty_generate(json_output)
    end

    unless Rails.env.development?
      object = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
      object.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(s3_path_folder(file_path)).upload_file(file_path, acl: 'public-read')
      File.delete(file_path)
    end
  end
end
