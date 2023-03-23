module FM::RM6232
  module GenerateSupplierDetails
    def self.truncate_tables
      FacilitiesManagement::RM6232::Supplier.destroy_all
    end

    def self.generate_suppliers_with_details
      50.times do
        FacilitiesManagement::RM6232::Supplier.create(supplier_name: Faker::Company.unique.name)
      end

      suppliers = FacilitiesManagement::RM6232::Supplier.all

      generate_supplier_details(suppliers)
    end

    def self.generate_supplier_details(suppliers)
      Faker::Config.locale = 'en-GB'

      suppliers.each do |supplier|
        data = {
          sme: rand > 0.75,
          duns: Faker::Company.unique.duns_number.gsub('-', ''),
          registration_number: "0#{rand(100000...999999)}",
          address_line_1: Faker::Address.street_address,
          address_line_2: rand > 0.5 ? Faker::Address.street_name : '',
          address_town: Faker::Address.city,
          address_county: Faker::Address.county,
          address_postcode: Faker::Address.postcode,
        }

        supplier.update(**data)
      end
    end
  end
end

# This task was created to generate the test data
# You should need to run it again as it will change the tests data and break tests
namespace :db do
  namespace :rm6232 do
    desc 'Generate the supplier details and save to xlsx'
    task generate_supplier_details: :environment do
      DistributedLocks.distributed_lock(192) do
        ActiveRecord::Base.transaction do
          FM::RM6232::GenerateSupplierDetails.truncate_tables
          FM::RM6232::GenerateSupplierDetails.generate_suppliers_with_details
        rescue ActiveRecord::Rollback => e
          logger.error e.message
        end
      end
    end

    desc 'Part of generating the full supplier details'
    task generate_suppliers: :generate_supplier_details
  end
end
