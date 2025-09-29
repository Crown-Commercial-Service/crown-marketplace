module FM::RM6232
  module GenerateTestData
    def self.generate_data
      generate_suppliers
      generate_lot_data
      write_to_file
    end

    def self.generate_suppliers
      @suppliers = (0..50).map do
        supplier_name = Faker::Company.unique.name.upcase
        Faker::Internet.domain_name(domain: supplier_name)

        {
          id: SecureRandom.uuid,
          name: supplier_name,
          duns_number: Faker::Company.unique.duns_number.delete('-').to_s,
          sme: rand < 0.5,
          supplier_frameworks: [
            {
              framework_id: 'RM6378',
              enabled: true,
              supplier_framework_lots: []
            }
          ]
        }
      end
    end

    def self.generate_lot_data
      generate_static_lot_data(..10, 'a', %w[1 2 3])
      generate_static_lot_data(6..15, 'b', %w[1 2 3])
      generate_static_lot_data(11..20, 'c', %w[1])
      generate_static_lot_data(..8, 'a', %w[4])
      generate_static_lot_data(5..12, 'b', %w[4])
      generate_static_lot_data(9..16, 'c', %w[4])
      generate_static_lot_data(13..20, 'd', %w[4])

      generate_random_lot_data(11..30, '1a')
      generate_random_lot_data(21..39, '1b')
      generate_random_lot_data(31..48, '1c')
      generate_random_lot_data(11..27, '2a')
      generate_random_lot_data(21..36, '2b')
      generate_random_lot_data(11..24, '3a')
      generate_random_lot_data(21..33, '3b')
      generate_random_lot_data(31..40, '4a')
      generate_random_lot_data(36..44, '4b')
      generate_random_lot_data(41..48, '4c')
      generate_random_lot_data(46..50, '4d')
    end

    def self.generate_static_lot_data(supplier_range, sub_lot, lot_numbers)
      lot_numbers.each do |lot_number|
        lot_id = "RM6378.#{lot_number}#{sub_lot}"

        service_numbers = Service.where(lot_id:).pluck(:number)

        @suppliers[supplier_range].each do |supplier|
          generate_services(supplier, lot_id, service_numbers)
        end
      end
    end

    def self.generate_random_lot_data(supplier_range, lot_number)
      lot_id = "RM6378.#{lot_number}"

      service_numbers = Service.where(lot_id:).pluck(:number)

      @suppliers[supplier_range].each do |supplier|
        serivce_numbers = service_numbers.sample(rand((service_numbers.length * (1 / 4.0)).to_i..(service_numbers.length * (3 / 4.0)).to_i)).sort

        generate_services(supplier, lot_id, serivce_numbers)
      end
    end

    def self.generate_services(supplier, lot_id, serivce_numbers)
      supplier_framework_lot = { lot_id: lot_id, enabled: true, supplier_framework_lot_services: [], supplier_framework_lot_rates: [], supplier_framework_lot_branches: [], supplier_framework_lot_jurisdictions: [] }

      serivce_numbers.each do |service_number|
        supplier_framework_lot[:supplier_framework_lot_services].append({ service_id: "#{lot_id}.#{service_number}" })
      end

      supplier[:supplier_frameworks][0][:supplier_framework_lots].append(supplier_framework_lot)
    end

    def self.write_to_file
      File.write('data/facilities_management/rm6378/dummy_supplier_data.json', JSON.pretty_generate(@suppliers))
    end
  end
end

namespace :fm do
  namespace :rm6378 do
    desc 'Generate test data for Facilities Management RM6378'
    task generate_test_data: :environment do
      FM::RM6232::GenerateTestData.generate_data
    end
  end
end
