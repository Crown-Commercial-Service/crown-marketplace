module LegalServices
  class Upload < ApplicationRecord
    def self.upload!(suppliers)
      error = all_or_none(Supplier) do
        Supplier.delete_all_with_dependents

        suppliers.map do |supplier_data|
          create_supplier!(supplier_data)
        end
        create!
      end
      raise error if error
    end

    def self.all_or_none(transaction_class)
      error = nil
      transaction_class.transaction do
        yield
      rescue ActiveRecord::RecordInvalid => e
        error = e
        raise ActiveRecord::Rollback
      end
      error
    end

    def self.create_supplier!(data)
      supplier = Supplier.create!(
        id: data['supplier_id'],
        name: data['name'],
        email: data['email'],
        phone_number: data['phone_number'],
        sme: data['sme'],
        address: data['address'],
        website: data['website'],
        duns: data['duns']
      )

      lot_1_services = data.fetch('lot_1_services', {})
      lot_1_services.each do |service|
        supplier.regional_availabilities.create!(
          region_code: service['region_code'],
          service_code: service['service_code']
        )
      end

      lots = data.fetch('lots', [])
      lots.each do |lot|
        lot_number = lot['lot_number']

        services = lot.fetch('services', [])
        services.each do |service|
          supplier.service_offerings.create!(
            lot_number: lot_number,
            service_code: service
          )
        end
      end
    end
  end
end
