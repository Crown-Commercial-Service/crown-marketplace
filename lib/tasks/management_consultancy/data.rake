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

    touch './storage/management_consultancy/current_data/output/errors.out'
    add_suppliers
    add_service_offerings_per_supplier
    add_region_availability_per_lot_per_supplier
    add_rate_cards_to_suppliers
  end
end
