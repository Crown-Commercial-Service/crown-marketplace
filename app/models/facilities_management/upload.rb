module FacilitiesManagement
  class Upload < ApplicationRecord
    def self.upload_json!(suppliers)
      error = all_or_none(CCS::FM::Supplier) do
        # Supplier.delete_all_with_dependents

        suppliers.map do |supplier_data|
          CCS::FM::Supplier.find_by(supplier_id: supplier_data['supplier_id']).try(:destroy)
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
      CCS :FM::Supplier.create!(
        supplier_id: data['supplier_id'],
        data: data
      )
    end
  end
end
