require 'bundler/setup'
require 'json'
require 'csv'

def add_vendor_contacts
  suppliers = JSON.parse(File.read('./public/supply_teachers/output/data_only_accredited.json'))

  master_details =
    CSV.new(File.read('./public/supply_teachers/input/master_vendor_contacts.csv'), headers: :first_row)
      .map { |r| [r['supplier_name'], r] }
      .to_h

  neutral_details =
    CSV.new(File.read('./public/supply_teachers/input/neutral_vendor_contacts.csv'), headers: :first_row)
      .map { |r| [r['supplier_name'], r] }
      .to_h

  suppliers.map! do |supplier|
    supplier_name = supplier.fetch('supplier_name')

    master = master_details[supplier_name]
    if master
      supplier.merge!(
        'master_vendor_contact' => {
          'name'      => master.fetch('contact_name'),
          'telephone' => master.fetch('contact_telephone'),
          'email'     => master.fetch('contact_email')
        }
      )
    end

    neutral = neutral_details[supplier_name]
    if neutral
      supplier.merge!(
        'neutral_vendor_contact' => {
          'name'      => neutral.fetch('contact_name'),
          'telephone' => neutral.fetch('contact_telephone'),
          'email'     => neutral.fetch('contact_email')
        }
      )
    end

    supplier
  end

  File.open('./public/supply_teachers/output/data_with_vendors.json.tmp', 'w') do |f|
    f.puts JSON.pretty_generate(suppliers)
  end
end