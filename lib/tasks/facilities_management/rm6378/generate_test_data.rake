module FM::RM6232
  module GenerateTestData
    class << self
      def generate_data
        generate_suppliers
        generate_lot_data
        write_to_file
      end

      private

      def generate_suppliers
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

      def generate_lot_data
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

      def generate_static_lot_data(supplier_range, sub_lot, lot_numbers)
        lot_numbers.each do |lot_number|
          lot_id = "RM6378.#{lot_number}#{sub_lot}"

          service_ids = service_ids_grouped_by_lot_id[lot_id]

          @suppliers[supplier_range].each do |supplier|
            generate_services(supplier, lot_id, service_ids)
            generate_jurisdictions(supplier, lot_id, jurisdiction_ids)
          end
        end
      end

      def generate_random_lot_data(supplier_range, lot_number)
        lot_id = "RM6378.#{lot_number}"

        service_ids = service_ids_grouped_by_lot_id[lot_id]

        @suppliers[supplier_range].each do |supplier|
          generate_services(supplier, lot_id, random_ids(service_ids))
          generate_jurisdictions(supplier, lot_id, random_ids(jurisdiction_ids))
        end
      end

      def generate_services(supplier, lot_id, service_ids)
        supplier_framework_lot = { lot_id: lot_id, enabled: true, supplier_framework_lot_services: [], supplier_framework_lot_rates: [], supplier_framework_lot_branches: [], supplier_framework_lot_jurisdictions: [] }

        service_ids.each do |service_id|
          supplier_framework_lot[:supplier_framework_lot_services].append({ service_id: })
        end

        supplier[:supplier_frameworks][0][:supplier_framework_lots].append(supplier_framework_lot)
      end

      def generate_jurisdictions(supplier, lot_id, jurisdiction_ids)
        supplier_framework_lot = supplier[:supplier_frameworks][0][:supplier_framework_lots].find { |supplier_framework_lot| supplier_framework_lot[:lot_id] == lot_id }

        jurisdiction_ids.each do |jurisdiction_id|
          supplier_framework_lot[:supplier_framework_lot_jurisdictions].append({ jurisdiction_id: })
        end
      end

      def write_to_file
        File.write('data/facilities_management/rm6378/dummy_supplier_data.json', JSON.pretty_generate(@suppliers))
      end

      def service_ids_grouped_by_lot_id
        @service_ids_grouped_by_lot_id ||= Service.where(lot_id: Framework.find('RM6378').lots).pluck(:id).group_by { |service| service[..8] }
      end

      def jurisdiction_ids
        @jurisdiction_ids ||= Jurisdiction.where.not(category: %i[core non-core]).pluck(:id)
      end

      def random_ids(ids)
        ids.sample(rand((ids.length * (1 / 4.0)).to_i..(ids.length * (3 / 4.0)).to_i)).sort
      end
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
