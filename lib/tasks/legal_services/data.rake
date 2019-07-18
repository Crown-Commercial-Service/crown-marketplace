require 'fileutils'

namespace :ls do
  task :clean do
    rm_f Dir[Rails.root.join('storage', 'legal_services', 'current_data', 'output', '*.tmp')]
    rm_f Dir[Rails.root.join('storage', 'legal_services', 'current_data', 'output', '*.json')]
    rm_f Dir[Rails.root.join('storage', 'legal_services', 'current_data', 'output', '*.out')]
  end

  task data: :environment do
    require Rails.root.join('lib', 'tasks', 'legal_services', 'scripts', 'add_suppliers.rb')

    FileUtils.makedirs(Rails.root.join('storage', 'legal_services', 'current_data', 'output'))
    FileUtils.touch(Rails.root.join('storage', 'legal_services', 'current_data', 'output', 'errors.out'))

    run_script(add_suppliers)
    # we are using test data on non-production environment so this is not needed anymore
    # run_script(anonymize)
  end

  def run_script(script)
    File.open(get_output_file_path('errors.out'), 'a') do
      script.to_s
    end
  end

  def get_output_file_path(file_name)
    Rails.root.join('storage', 'legal_services', 'current_data', 'output', file_name)
  end
end
