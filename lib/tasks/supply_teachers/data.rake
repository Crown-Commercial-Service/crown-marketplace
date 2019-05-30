namespace :st do
  task :clean do
    rm_f Dir['./storage/supply_teachers/output/*.json']
    rm_f Dir['./storage/supply_teachers/output/*.out']
  end

  task :data do
    FileUtils.touch('./storage/supply_teachers/output/errors.out')
    require './lib/tasks/supply_teachers/scripts/generate_branches.rb'
    './storage/supply_teachers/output/errors.out' << generate_branches.to_s
    mv './storage/supply_teachers/output/supplier_branches.json.tmp', './storage/supply_teachers/output/supplier_branches.json'

    require './lib/tasks/supply_teachers/scripts/generate_pricing.rb'
    './storage/supply_teachers/output/errors.out' << generate_pricing.to_s
    mv './storage/supply_teachers/output/supplier_pricing.json.tmp', './storage/supply_teachers/output/supplier_pricing.json'

    require './lib/tasks/supply_teachers/scripts/generate_vendor_pricing.rb'
    './storage/supply_teachers/output/errors.out' << generate_vendor_pricing.to_s
    mv './storage/supply_teachers/output/supplier_vendor_pricing.json.tmp', './storage/supply_teachers/output/supplier_vendor_pricing.json'

    require './lib/tasks/supply_teachers/scripts/generate_accreditation.rb'
    './storage/supply_teachers/output/errors.out' << generate_accreditation.to_s
    mv './storage/supply_teachers/output/supplier_accreditation.json.tmp', './storage/supply_teachers/output/supplier_accreditation.json'

    require './lib/tasks/supply_teachers/scripts/merge_json.rb'
    './storage/supply_teachers/output/errors.out' << merge_json(supplier_name_key: 'pricing supplier name',
                                                                  destination_key: 'branches supplier name',
                                                                  destination_file: './storage/supply_teachers/output/data_branches_pricing.json.tmp',
                                                                  primary: './storage/supply_teachers/output/supplier_branches.json',
                                                                  secondary: './storage/supply_teachers/output/supplier_pricing.json',
                                                                  alias_file: './storage/supply_teachers/input/supplier_lookup.csv').to_s
    mv './storage/supply_teachers/output/data_branches_pricing.json.tmp', './storage/supply_teachers/output/data_branches_pricing.json'
    './storage/supply_teachers/output/errors.out' << merge_json(supplier_name_key: 'vendor supplier name',
                                                                  destination_key: 'branches supplier name',
                                                                  destination_file: './storage/supply_teachers/output/data_branches_pricing_vendors.json.tmp',
                                                                  primary: './storage/supply_teachers/output/data_branches_pricing.json',
                                                                  secondary: './storage/supply_teachers/output/supplier_vendor_pricing.json',
                                                                  alias_file: './storage/supply_teachers/input/supplier_lookup.csv').to_s
    mv './storage/supply_teachers/output/data_branches_pricing_vendors.json.tmp', './storage/supply_teachers/output/data_branches_pricing_vendors.json'
    './storage/supply_teachers/output/errors.out' << merge_json(supplier_name_key: 'accreditation supplier name',
                                                                  destination_key: 'branches supplier name',
                                                                  destination_file: './storage/supply_teachers/output/data_merged.json.tmp',
                                                                  primary: './storage/supply_teachers/output/data_branches_pricing_vendors.json',
                                                                  secondary: './storage/supply_teachers/output/supplier_accreditation.json',
                                                                  alias_file: './storage/supply_teachers/input/supplier_lookup.csv').to_s
    mv './storage/supply_teachers/output/data_merged.json.tmp', './storage/supply_teachers/output/data_merged.json'

    require './lib/tasks/supply_teachers/scripts/exclude_suppliers_without_accreditation.rb'
    './storage/supply_teachers/output/errors.out' << exclude_suppliers_without_accreditation.to_s
    mv './storage/supply_teachers/output/data_only_accredited.json.tmp', './storage/supply_teachers/output/data_only_accredited.json'

    require './lib/tasks/supply_teachers/scripts/add_vendor_contacts.rb'
    './storage/supply_teachers/output/errors.out' << add_vendor_contacts.to_s
    mv './storage/supply_teachers/output/data_with_vendors.json.tmp', './storage/supply_teachers/output/data_with_vendors.json'

    require './lib/tasks/supply_teachers/scripts/validate_and_geocode.rb'
    './storage/supply_teachers/output/errors.out' << validate_and_geocode.to_s
    mv './storage/supply_teachers/output/data_with_line_numbers.json.tmp', './storage/supply_teachers/output/data_with_line_numbers.json'

    require './lib/tasks/supply_teachers/scripts/strip_line_numbers.rb'
    './storage/supply_teachers/output/errors.out' << strip_line_numbers.to_s
    mv './storage/supply_teachers/output/data.json.tmp', './storage/supply_teachers/output/data.json'

    require './lib/tasks/supply_teachers/scripts/anonymize.rb'
    './storage/supply_teachers/output/errors.out' << anonymize.to_s
    mv './storage/supply_teachers/output/anonymous.json.tmp', './storage/supply_teachers/output/anonymous.json'

    require './lib/tasks/supply_teachers/scripts/bootstrap_supplier_lookup.rb'
    './storage/supply_teachers/output/errors.out' << bootstrap_supplier_lookup.to_s
    mv './storage/supply_teachers/output/supplier_lookup.csv.tmp', './storage/supply_teachers/output/supplier_lookup.csv'

  end
end