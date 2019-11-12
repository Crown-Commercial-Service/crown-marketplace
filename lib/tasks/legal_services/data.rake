require 'aws-sdk-s3'
require 'fileutils'

namespace :ls do
  task :clean do
    if Rails.env.development?
      rm_f Dir['storage/legal_services/current_data/output/*.tmp']
      rm_f Dir['storage/legal_services/current_data/output/*.json']
      rm_f Dir['storage/legal_services/current_data/output/*.out']
    else
      object = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
      object.bucket(ENV['CCS_APP_API_DATA_BUCKET']).objects({prefix: 'legal_services/current_data/output/'}).batch_delete!
    end
  end

  task data: :environment do
    require Rails.root.join('lib', 'tasks', 'legal_services', 'scripts', 'add_suppliers')
    require Rails.root.join('lib', 'tasks', 'legal_services', 'scripts', 'add_lot_1_services_per_supplier')
    require Rails.root.join('lib', 'tasks', 'legal_services', 'scripts', 'add_lot_2_services_per_supplier')
    require Rails.root.join('lib', 'tasks', 'legal_services', 'scripts', 'add_lot_3_and_4_services_per_supplier')
    require Rails.root.join('lib', 'tasks', 'legal_services', 'scripts', 'add_rate_cards_to_suppliers')

    FileUtils.makedirs(Rails.root.join('storage', 'legal_services', 'current_data', 'output'))
    FileUtils.touch(Rails.root.join('storage', 'legal_services', 'current_data', 'output', 'errors.out'))

    run_script add_suppliers
    run_script add_lot_1_services_per_supplier
    run_script add_lot_2_services_per_supplier
    run_script add_lot_3_and_4_services_per_supplier
    run_script add_rate_cards_to_suppliers

    unless Rails.env.development?
      object = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
      object.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(s3_path_folder(get_ls_output_file_path('data.json').to_s)).upload_file(get_ls_output_file_path('data.json'), {acl:'private'})
      object.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(s3_path_folder(get_ls_output_file_path('errors.out').to_s)).upload_file(get_ls_output_file_path('errors.out'), {acl:'private'}) unless File.zero?(get_ls_output_file_path('errors.out'))
    end
  end

  def run_script(script)
    File.open(get_ls_output_file_path('errors.out'), 'a') do
      script.to_s
    end
  end

  def get_ls_output_file_path(file_name)
    Rails.root.join('storage', 'legal_services', 'current_data', 'output', file_name)
  end

  def file_path(path)
    return path if Rails.env.development?
    s3_path(path.to_s)
  end

  def s3_path(path)
    "https://s3-#{ENV['COGNITO_AWS_REGION']}.amazonaws.com/#{ENV['CCS_APP_API_DATA_BUCKET']}/#{s3_path_folder(path.to_s)}"
  end

  def s3_path_folder(path)
    path.slice((path.index('storage/') + 8)..path.length)
  end

  def write_ls_output_file(file_name, json_output)
    file_path = get_ls_output_file_path(file_name)
    File.open(file_path, 'w') do |f|
      f.puts JSON.pretty_generate(json_output)
    end
  end
end
