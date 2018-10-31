class FacilitiesManagementUpload
  def self.create!(suppliers)
    error = all_or_none(FacilitiesManagementSupplier) do
      FacilitiesManagementSupplier.destroy_all

      suppliers.map do |supplier_data|
        create_supplier!(supplier_data)
      end
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
    FacilitiesManagementSupplier.create!(
      id: data['supplier_id'],
      name: data['supplier_name'],
      contact_name: data['contact_name']
    )
  end
end
