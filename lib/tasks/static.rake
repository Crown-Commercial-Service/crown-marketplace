namespace :db do
  desc 'add static data to the database'
  task static: :environment

  desc 'add static data to the database'
  task setup: :static

  desc 'add static data to the database'
  task static: :bank_holidays

  desc 'add static data to the database'
  task static: :frameworks

  desc 'add static data to the database'
  task static: :sample_address_import

  desc 'add NUTS regions to the database'
  task static: :regions

  desc 'add building Security Types to the database'
  task static: :'rm3830:security_types'

  desc 'add FM static data to the database'
  task static: :'rm3830:fmdata'

  desc 'add FM rates to the database'
  task static: :'rm3830:fm_rates'

  desc 'add static data to the database'
  task static: :'rm3830:fm_supplier_data'

  desc 'add Services for RM6232 to the database'
  task static: :'rm6232:import_services'

  desc 'add Suppliers for RM6232 to the database'
  task static: :'rm6232:import_suppliers'

  desc 'add static data to the database'
  task static: :update_frameworks
end
