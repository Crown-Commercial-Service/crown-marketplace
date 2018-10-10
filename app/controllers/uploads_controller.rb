class UploadsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    suppliers = JSON.parse(request.body.read)

    error = all_or_none(Supplier) do
      Supplier.destroy_all

      suppliers.map do |supplier_data|
        create_supplier!(supplier_data)
      end
    end

    raise error if error

    render json: {}, status: :created
  end

  private

  def all_or_none(transaction_class)
    error = nil
    transaction_class.transaction do
      yield
    rescue ActiveRecord::RecordInvalid => e
      error = e
      raise ActiveRecord::Rollback
    end
    error
  end

  def create_supplier!(data)
    s = Supplier.create!(id: data['supplier_id'], name: data['supplier_name'])
    branches = data.fetch('branches', [])
    branches.each do |branch|
      contact_name = branch.dig('contacts', 0, 'name')
      contact_email = branch.dig('contacts', 0, 'email')
      s.branches.create!(
        postcode: branch['postcode'],
        contact_name: contact_name,
        contact_email: contact_email
      )
    end
  end
end
