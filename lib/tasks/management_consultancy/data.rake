namespace :mc do
  task :clean do
    rm_f Dir['./lib/tasks/management_consultancy/output/*.json']
    rm_f Dir['./lib/tasks/management_consultancy/output/*.out']
  end

  task data: ['./lib/tasks/management_consultancy/output/data.json', './lib/tasks/management_consultancy/output/anonymous.json']

  file './lib/tasks/management_consultancy/output/suppliers.json' => Dir['./lib/tasks/management_consultancy/input/**.xlsx'] do |t|
    sh "./lib/tasks/management_consultancy/scripts/add_suppliers.rb > #{t.name}.tmp 2>> ./lib/tasks/management_consultancy/output/errors.out"
    mv "#{t.name}.tmp", t.name
  end

  file './lib/tasks/management_consultancy/output/suppliers_with_service_offerings.json' => Dir['./lib/tasks/management_consultancy/input/**.xlsx'] do |t|
    sh "./lib/tasks/management_consultancy/scripts/add_service_offerings_per_supplier.rb > #{t.name}.tmp 2>> ./lib/tasks/management_consultancy/output/errors.out"
    mv "#{t.name}.tmp", t.name
  end

  file './lib/tasks/management_consultancy/output/suppliers_with_service_offerings_and_regional_availability.json' => Dir['./lib/tasks/management_consultancy/input/**.xlsx'] do |t|
    sh "./lib/tasks/management_consultancy/scripts/add_region_availability_per_lot_per_supplier.rb > #{t.name}.tmp 2>> ./lib/tasks/management_consultancy/output/errors.out"
    mv "#{t.name}.tmp", t.name
  end

  file './lib/tasks/management_consultancy/output/suppliers_with_service_offerings_and_regional_availability_and_rate_cards.json' => Dir['./lib/tasks/management_consultancy/input/**.xlsx'] do |t|
    sh "./lib/tasks/management_consultancy/scripts/add_rate_cards_to_suppliers.rb > #{t.name}.tmp 2>> ./lib/tasks/management_consultancy/output/errors.out"
    mv "#{t.name}.tmp", t.name
  end

  # cp './lib/tasks/management_consultancy/output/suppliers_with_service_offerings_and_regional_availability_and_rate_cards.json', './lib/tasks/management_consultancy/output/data.json'
end
