require 'aws-sdk-s3'
require 'fileutils'

namespace :mc do
  task :clean do
    rm_f Dir[Rails.root.join('storage', 'management_consultancy', 'current_data', 'output', '*.tmp')]
    rm_f Dir[Rails.root.join('storage', 'management_consultancy', 'current_data', 'output', '*.json')]
    rm_f Dir[Rails.root.join('storage', 'management_consultancy', 'current_data', 'output', '*.out')]
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

  def get_mc_output_file_path(file_name)
    Rails.root.join('storage', 'management_consultancy', 'current_data', 'output', file_name)
  end
end
