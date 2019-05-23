namespace :st do
  task :clean do
    rm_f Dir['./public/supply_teachers/output/*.json']
    rm_f Dir['./public/supply_teachers/output/*.out']
  end

  task :data do
    FileUtils.touch('./public/supply_teachers/output/errors.out')
    require './lib/tasks/supply_teachers/scripts/generate_branches.rb'
    './public/supply_teachers/output/errors.out' << generate_branches.to_s
    mv './public/supply_teachers/output/supplier_branches.json.tmp', './public/supply_teachers/output/supplier_branches.json'

    require './lib/tasks/supply_teachers/scripts/generate_pricing.rb'
    './public/supply_teachers/output/errors.out' << generate_pricing.to_s
    mv './public/supply_teachers/output/supplier_pricing.json.tmp', './public/supply_teachers/output/supplier_pricing.json'

    require './lib/tasks/supply_teachers/scripts/generate_vendor_pricing.rb'
    './public/supply_teachers/output/errors.out' << generate_vendor_pricing.to_s
    mv './public/supply_teachers/output/supplier_vendor_pricing.json.tmp', './public/supply_teachers/output/supplier_vendor_pricing.json'

    require './lib/tasks/supply_teachers/scripts/generate_accreditation.rb'
    './public/supply_teachers/output/errors.out' << generate_accreditation.to_s
    mv './public/supply_teachers/output/supplier_accreditation.json.tmp', './public/supply_teachers/output/supplier_accreditation.json'

    require './lib/tasks/supply_teachers/scripts/merge_json.rb'
    './public/supply_teachers/output/errors.out' << merge_json(supplier_name_key: 'pricing supplier name',
                                                                  destination_key: 'branches supplier name',
                                                                  destination_file: './public/supply_teachers/output/data_branches_pricing.json.tmp',
                                                                  primary: './public/supply_teachers/output/supplier_branches.json',
                                                                  secondary: './public/supply_teachers/output/supplier_pricing.json',
                                                                  alias_file: './public/supply_teachers/input/supplier_lookup.csv').to_s
    mv './public/supply_teachers/output/data_branches_pricing.json.tmp', './public/supply_teachers/output/data_branches_pricing.json'
    './public/supply_teachers/output/errors.out' << merge_json(supplier_name_key: 'vendor supplier name',
                                                                  destination_key: 'branches supplier name',
                                                                  destination_file: './public/supply_teachers/output/data_branches_pricing_vendors.json.tmp',
                                                                  primary: './public/supply_teachers/output/data_branches_pricing.json',
                                                                  secondary: './public/supply_teachers/output/supplier_vendor_pricing.json',
                                                                  alias_file: './public/supply_teachers/input/supplier_lookup.csv').to_s
    mv './public/supply_teachers/output/data_branches_pricing_vendors.json.tmp', './public/supply_teachers/output/data_branches_pricing_vendors.json'
    './public/supply_teachers/output/errors.out' << merge_json(supplier_name_key: 'accreditation supplier name',
                                                                  destination_key: 'branches supplier name',
                                                                  destination_file: './public/supply_teachers/output/data_merged.json.tmp',
                                                                  primary: './public/supply_teachers/output/data_branches_pricing_vendors.json',
                                                                  secondary: './public/supply_teachers/output/supplier_accreditation.json',
                                                                  alias_file: './public/supply_teachers/input/supplier_lookup.csv').to_s
    mv './public/supply_teachers/output/data_merged.json.tmp', './public/supply_teachers/output/data_merged.json'

    require './lib/tasks/supply_teachers/scripts/exclude_suppliers_without_accreditation.rb'
    './public/supply_teachers/output/errors.out' << exclude_suppliers_without_accreditation.to_s
    mv './public/supply_teachers/output/data_only_accredited.json.tmp', './public/supply_teachers/output/data_only_accredited.json'

    require './lib/tasks/supply_teachers/scripts/add_vendor_contacts.rb'
    './public/supply_teachers/output/errors.out' << add_vendor_contacts.to_s
    mv './public/supply_teachers/output/data_with_vendors.json.tmp', './public/supply_teachers/output/data_with_vendors.json'

    require './lib/tasks/supply_teachers/scripts/validate_and_geocode.rb'
    './public/supply_teachers/output/errors.out' << validate_and_geocode.to_s
    mv './public/supply_teachers/output/data_with_line_numbers.json.tmp', './public/supply_teachers/output/data_with_line_numbers.json'

    require './lib/tasks/supply_teachers/scripts/strip_line_numbers.rb'
    './public/supply_teachers/output/errors.out' << strip_line_numbers.to_s
    mv './public/supply_teachers/output/data.json.tmp', './public/supply_teachers/output/data.json'

    require './lib/tasks/supply_teachers/scripts/anonymize.rb'
    './public/supply_teachers/output/errors.out' << anonymize.to_s
    mv './public/supply_teachers/output/anonymous.json.tmp', './public/supply_teachers/output/anonymous.json'

    require './lib/tasks/supply_teachers/scripts/bootstrap_supplier_lookup.rb'
    './public/supply_teachers/output/errors.out' << bootstrap_supplier_lookup.to_s
    mv './public/supply_teachers/output/supplier_lookup.csv.tmp', './public/supply_teachers/output/supplier_lookup.csv'

  end
end