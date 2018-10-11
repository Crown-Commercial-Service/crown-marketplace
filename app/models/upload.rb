class Upload
  def self.create!(suppliers)
    error = all_or_none(Supplier) do
      Supplier.destroy_all

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
    s = Supplier.create!(
      id: data['supplier_id'],
      name: data['supplier_name'],
      accreditation_body: data['accreditation']
    )
    branches = data.fetch('branches', [])
    branches.each do |branch|
      contact_name = branch.dig('contacts', 0, 'name')
      contact_email = branch.dig('contacts', 0, 'email')
      s.branches.create!(
        postcode: branch['postcode'],
        location: Geocoding.point(
          latitude: branch['lat'],
          longitude: branch['lon']
        ),
        telephone_number: branch['telephone'],
        contact_name: contact_name,
        contact_email: contact_email
      )
    end
  end
end
