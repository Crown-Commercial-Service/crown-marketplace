module FacilitiesManagement
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

    def self.upload_json!(suppliers)
      error = all_or_none(Supplier) do
        Supplier.delete_all_with_dependents

        suppliers.map do |supplier_data|
          CCS::FM::Supplier.find(supplier_data['supplier_id']).destroy
          CCS::FM::Supplier.create!(
            supplier_id: supplier_data['supplier_id'],
            data: supplier_data
          )
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
        name: data['supplier_name'],
        contact_name: data['contact_name'],
        contact_email: data['contact_email'],
        telephone_number: data['contact_phone']
      )

      lots = data.fetch('lots', [])
      lots.each do |lot|
        lot_number = lot['lot_number']
        regions = lot.fetch('regions', [])
        regions.each do |region|
          supplier.regional_availabilities.create!(
            lot_number: lot_number,
            region_code: region
          )
        end
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
