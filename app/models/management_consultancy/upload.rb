module ManagementConsultancy
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
        contact_email: data['contact_email'],
        telephone_number: data['telephone_number'],
        sme: data['sme'],
        address: data['address'],
        website: data['website'],
        duns: data['duns']
      )

      lots = data.fetch('lots', [])
      lots.each do |lot|
        lot_number = lot['lot_number']
        regions = lot.fetch('regions', {})
        regions.each do |region, policy|
          supplier.regional_availabilities.create!(
            lot_number: lot_number,
            region_code: region,
            expenses_required: policy == 'provided_if_expenses'
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

      rate_cards = data.fetch('rate_cards', [])

      rate_cards.each do |rate_card|
        supplier.rate_cards.create!(rate_card)
      end
    end
  end
end
