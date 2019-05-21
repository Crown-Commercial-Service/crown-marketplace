namespace :st do
  task :clean do
    rm_f Dir[Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', '*.json')]
    rm_f Dir[Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', '*.out')]
  end

  task data: [Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'data.json'), Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'anonymous.json')]

  file Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'supplier_branches.json') => Dir[Rails.root.join('lib', 'tasks', 'supply_teachers', 'input', '**.xlsx')] do |t|
    sh "#{Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'generate_branches.rb')} > #{t.name}.tmp 2>> #{Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'errors.out')}"
    mv "#{t.name}.tmp", t.name
  end

  file Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'supplier_pricing.json') => Dir[Rails.root.join('lib', 'tasks', 'supply_teachers', 'input', '**.xlsx')] do |t|
    sh "#{Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'generate_pricing.rb')} > #{t.name}.tmp 2>> #{Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'errors.out')}"
    mv "#{t.name}.tmp", t.name
  end

  file Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'supplier_vendor_pricing.json') => Dir[Rails.root.join('lib', 'tasks', 'supply_teachers', 'input', '**.xlsx')] do |t|
    sh "#{Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'generate_vendor_pricing.rb')} > #{t.name}.tmp 2>> #{Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'errors.out')}"
    mv "#{t.name}.tmp", t.name
  end

  file Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'supplier_accreditation.json') => Dir[Rails.root.join('lib', 'tasks', 'supply_teachers', 'input', '**.xlsx')] do |t|
    sh "#{Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'generate_accreditation.rb')} > #{t.name}.tmp 2>> #{Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'errors.out')}"
    mv "#{t.name}.tmp", t.name
  end

  file Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'data_branches_pricing.json') => [Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'supplier_branches.json'), Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'supplier_pricing.json'), Rails.root.join('lib', 'tasks', 'supply_teachers', 'input', 'supplier_lookup.csv')] do |t|
    sh "#{Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'merge_json.rb')} --aliases #{t.prerequisites[2]} -s 'pricing supplier name' -d 'branches supplier name' -k supplier_name #{t.prerequisites[0]} #{t.prerequisites[1]} > #{t.name}.tmp 2>> #{Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'errors.out')}"
    mv "#{t.name}.tmp", t.name
  end

  file Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'data_branches_pricing_vendors.json') => [Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'data_branches_pricing.json'), Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'supplier_vendor_pricing.json'), Rails.root.join('lib', 'tasks', 'supply_teachers', 'input', 'supplier_lookup.csv')] do |t|
    sh "#{Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'merge_json.rb')} --aliases #{t.prerequisites[2]} -s 'vendor supplier name' -d 'branches supplier name' -k supplier_name #{t.prerequisites[0]} #{t.prerequisites[1]} > #{t.name}.tmp 2>> #{Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'errors.out')}"
    mv "#{t.name}.tmp", t.name
  end

  file Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'data_merged.json') => [Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'data_branches_pricing_vendors.json'), Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'supplier_accreditation.json'), Rails.root.join('lib', 'tasks', 'supply_teachers', 'input', 'supplier_lookup.csv')] do |t|
    sh "#{Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'merge_json.rb')} --aliases #{t.prerequisites[2]} -s 'accreditation supplier name' -d 'branches supplier name' -k supplier_name #{t.prerequisites[0]} #{t.prerequisites[1]} > #{t.name}.tmp 2>> #{Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'errors.out')}"
    mv "#{t.name}.tmp", t.name
  end

  file Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'data_only_accredited.json') => Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'data_merged.json') do |t|
    sh "#{Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'exclude_suppliers_without_accreditation.rb')} < #{t.source} > #{t.name}.tmp"
    mv "#{t.name}.tmp", t.name
  end

  file Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'data_with_vendors.json') => [Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'data_only_accredited.json'), Rails.root.join('lib', 'tasks', 'supply_teachers', 'input', 'neutral_vendor_contacts.csv'), Rails.root.join('lib', 'tasks', 'supply_teachers', 'input', 'master_vendor_contacts.csv')] do |t|
    sh "ruby #{Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'add_vendor_contacts.rb')} #{t.sources.join(' ')} > #{t.name}.tmp"
    mv "#{t.name}.tmp", t.name
  end


  file Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'data_with_line_numbers.json') => Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'data_with_vendors.json') do |t|
    sh "ruby #{Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'validate_and_geocode.rb')} < #{t.source} > #{t.name}.tmp 2>> #{Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'errors.out')}"
    mv "#{t.name}.tmp", t.name
  end

  file Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'data.json') => Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'data_with_line_numbers.json') do |t|
    sh "ruby #{Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'strip_line_numbers.rb')} < #{t.source} > #{t.name}.tmp 2>> #{Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'errors.out')}"
    mv "#{t.name}.tmp", t.name
  end

  file Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'anonymous.json') => Rails.root.join('lib', 'tasks', 'supply_teachers', 'output', 'data.json') do |t|
    sh "#{Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'anonymize.rb')} < #{t.source} > #{t.name}.tmp"
    mv "#{t.name}.tmp", t.name
  end

  file Rails.root.join('lib', 'tasks', 'supply_teachers', 'input', 'supplier_lookup.csv') do |t|
    sh "#{Rails.root.join('lib', 'tasks', 'supply_teachers', 'scripts', 'bootstrap_supplier_lookup.rb')} > #{t.name}.tmp"
    mv "#{t.name}.tmp", t.name
  end

end
