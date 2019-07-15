 LegalServices
  class Upload < ApplicationRecord
    def self.upload!(suppliers)
      error = all_or_none(Supplier) do

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
        website: data['website'],
        address: data['address'],
        sme: data['sme'],
        duns: data['duns'],
        lot1: data['lot1'],
        lot2: data['lot2'],
        lot3: data['lot3'],
        lot4: data['lot4']
      )

      services.save!
    end
  end
end
