require 'fileutils'

namespace :ls do
  task :clean do
    rm_f Dir[Rails.root.join('storage', 'legal_services', 'current_data', 'output', '*.tmp')]
    rm_f Dir[Rails.root.join('storage', 'legal_services', 'current_data', 'output', '*.json')]
    rm_f Dir[Rails.root.join('storage', 'legal_services', 'current_data', 'output', '*.out')]
  end
end
